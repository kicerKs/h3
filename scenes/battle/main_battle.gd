class_name Battle extends Node

const scene: PackedScene = preload("res://scenes/battle/mainBattle.tscn")

var playerArmy: Array[Mob] = []
var enemyArmy: Array[Mob] = []

var fight_sequence: Array[Mob] = []
var initial_queue: Array[Mob] = []
var morale_wait_queue: Array[Mob] = []
var wait_queue: Array[Mob] = []
var actual_plaing_mob: Mob
var projectile: Sprite2D
var def_anim: DefAnim
var random = RandomNumberGenerator.new()
var hero: Hero
var obstacles: Dictionary
var oponent: Array[ArmyUnit]
var target: Mob

var controls: Controls
var mobs_node: Node
var retreat_popup: PopupWindow
var surrender_popup: PopupWindow
var battle_ground: Battleground
var stats_window: StatsWindow
var block_actions: bool
var morale_round = false

static var round_count = 1

signal return_hero_to_castle(Hero)
signal battle_end(Hero, bool)

static func new_battle(hero:Hero, oponent:Array[ArmyUnit]):
	var battle: Battle = scene.instantiate()
	battle.hero = hero
	battle.oponent = oponent
	return battle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mobs_node = $Mobs
	controls = $Controls
	retreat_popup = $RetreatPopup
	surrender_popup = $SurrenderPopup
	projectile = $Projectile
	def_anim = $DefAnim
	battle_ground = $Battleground
	stats_window = $StatsWindow
	projectile.position = battle_ground.map_to_local(Vector2i(-10,-10))
	def_anim.position = battle_ground.map_to_local(Vector2i(-10,-10))
	round_count = 0
	
	#hero = Hero.new()
	#hero.attributes = load("res://scenes/hero/presets/hero_preset_1.tres")
	#hero.army = [
	#	ArmyUnit.nowy(load("res://scenes/units/presets/angel.tres"), 1),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/cyborg.tres"), 12),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/firebat.tres"), 3),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/tank.tres"), 8),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/marine.tres"), 8),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/sniper.tres"), 8),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/soldier.tres"), 8),
	#]
	#oponent = [
	#	ArmyUnit.nowy(load("res://scenes/units/presets/cyborg.tres"), 1),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/sniper.tres"), 1),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/soldier.tres"), 1),
	#	ArmyUnit.nowy(load("res://scenes/units/presets/marine.tres"), 1)
	#]
	battle_ground.clear_fields()
	add_obstacles()
	bound_control_buttons()
	set_battle(hero, oponent)
	fight_sequence.append_array(mobs_node.get_children())
	fight_sequence.sort_custom(mob_sort)

func bound_control_buttons():
	controls.wait_button_signal.connect(mob_wait)
	controls.defend_button_signal.connect(mob_defense)
	controls.retreat_button_signal.connect(try_to_retreat)
	controls.surrender_button_signal.connect(try_to_surrender)
	retreat_popup.approve_button_down.connect(retreat)

func add_obstacles():
	match(random.randi_range(0,2)):
		0: obstacles = ObstaclePatterns.pattern1
		1: obstacles = ObstaclePatterns.pattern2
		2: obstacles = ObstaclePatterns.pattern3
	for cell in obstacles.keys():
		battle_ground.put_obstacle(cell, obstacles[cell])

func mob_sort(mob1: Mob, mob2: Mob):
	if(mob1.get_speed() > mob2.get_speed()):
		return true
	return false

func next_mob():
	erase_dead_mobs()
	if(morale_round and actual_plaing_mob.hp_stack > 0):
		initial_queue.push_front(actual_plaing_mob)
		#jakaś animacja morali
	if initial_queue.size() == 0 and morale_wait_queue.size() == 0 and wait_queue.size() == 0:
		round_count += 1
		initial_queue = fight_sequence.duplicate(true)
		for mob: Mob in initial_queue:
			mob.counterattack = true
			mob.defense_boost = false
	
	check_win()
	redraw_heads()
	redraw_labels()
	actual_plaing_mob = get_mob_from_queues()
	button_lock()
	actual_plaing_mob.mob_play.emit()

func erase_dead_mobs():
	var new_sequence:Array[Mob] = []
	for mob in fight_sequence:
		if(mob.stack <= 0):
			initial_queue.erase(mob)
			morale_wait_queue.erase(mob)
			wait_queue.erase(mob)#tutaj może być problem, że martwy mob chce się ruszyć??? albo coś nie tak ze zwalnianiem pozycji po śmierci
			if(mob.visible):
				mob.visible = false
				battle_ground.set_enable(battle_ground.local_to_map(mob.position))
		else:
			new_sequence.append(mob)
	fight_sequence = new_sequence

func check_win():
	var player_win = true
	for mob in enemyArmy:
		if(mob.stack > 0):
			player_win = false
	if(player_win):
		rebuild_hero_army()
		battle_end.emit(hero, true)
		return
		
	var enemy_win = true
	for mob in playerArmy:
		if(mob.stack > 0):
			enemy_win = false
	if(enemy_win):
		battle_end.emit(hero, false)

func get_mob_from_queues() -> Mob:
	if initial_queue.size() != 0:
		return initial_queue.pop_front()
	elif morale_wait_queue.size() != 0:
		return morale_wait_queue.pop_front()
	elif wait_queue.size() != 0:
		return wait_queue.pop_front()
	else:
		return null

func redraw_heads():
	controls.clear_heads()
	var size = 0
	for queue in [initial_queue, morale_wait_queue, wait_queue]:
		for mob: Mob in queue:
			if(size < 14):
				controls.add_mob_icon(mob)
				size+=1
	while size < 14:
		controls.add_bar_to_icons()
		size+=1
		for mob: Mob in fight_sequence:
			if(size < 14 and mob.stack > 0):
				controls.add_mob_icon(mob)
				size+=1

func redraw_labels():
	for mob in fight_sequence:
		mob.side_label()
		if(battle_ground.is_taken(Vector2i(battle_ground.local_to_map(mob.position).x+1,battle_ground.local_to_map(mob.position).y))):
			mob.center_label()
	

func button_lock():
	if actual_plaing_mob.player :
		controls.unlock_all_buttons()
	else:
		controls.lock_all_buttons()
	if initial_queue.size() == 0:
		controls.lock_wait_button()

func attackMob(mob: Mob, side: Mob.Part):
	if(block_actions): return
	
	if(actual_plaing_mob.distant and battle_ground.straight_distance_mobs(actual_plaing_mob, mob) > 1):
		distant_attack(mob)
	else:
		melee_attack(mob, side)

func distant_attack(mob: Mob):
	projectile.position = actual_plaing_mob.position
	projectile.texture = load("res://assets/projectiles.png") #w przyszłości zrobić funkcję wyboru różnych projectili
	projectile.rotation = 0
	var a = actual_plaing_mob.position.x - mob.position.x
	var b = actual_plaing_mob.position.y - mob.position.y
	var c = sqrt(a**2+b**2)
	var angle = asin(abs(b)/c)
	projectile.rotate((angle) if(a*b>=0) else (PI-angle))
	projectile.visible = false
	target = mob
	find_child("StateMachine").transition_to_state(BattleTurnState.PROJECTILE_FLY)

func melee_attack(mob: Mob, side: Mob.Part):
	if(!battle_ground.has_range_on_side(mob, side) or 
		(playerArmy.find(actual_plaing_mob)>=0 and playerArmy.find(mob)>=0)):
		return 
	
	battle_ground.placeMobAt(actual_plaing_mob,battle_ground.cell_on_side(mob,side))
	target = mob
	find_child("StateMachine").transition_to_state(BattleTurnState.ATTACK)

func fight(distant: bool = false):
	#TODO tutaj jest potrzbny minus dla dystansowych jednostek bijących melee
	target.hp_stack -= _calculate_attack_value(actual_plaing_mob, target, distant)
	if(target.hp_stack>0 and target.counterattack and !distant):
		actual_plaing_mob.hp_stack -= _calculate_attack_value(target, actual_plaing_mob)
	if(target.stack <= 0):
		target = null

func _calculate_attack_value(attacker: Mob, defender: Mob, distance_attack: bool = false) -> int:
	var A = attacker.attack + (0 if !attacker.player else hero.attributes.attack)
	var D = defender.defense + (0 if !defender.player else hero.attributes.defense)
	var luck = 0 if(!attacker.player) else (1 if(random.randf() < float(float(hero.luck)/24.0)) else 0)
	
	var i1 = 0.0 if(A>=D) else 0.05*(A-D)
	var i2 = 0.0 if !attacker.player else (hero.attributes.get_archery_modifier() if distance_attack else hero.attributes.get_offence_modifier())
	var R1 = 0.0 if(D>=A) else 0.025*(D-A)
	var R2 = 0.0 if !defender.player else hero.attributes.get_armorer_modifier()
	var R5 = 0.0
	if(distance_attack and battle_ground.straight_distance_mobs(actual_plaing_mob,target) > 10 or !distance_attack and actual_plaing_mob.distant):
		R5 = 0.5
	return roundi(_conut_base_attack() * (1.0+i1+i2+luck) * (1.0-R1) * (1.0-R2) * (1.0-R5))

func _conut_base_attack() -> float:
	if(actual_plaing_mob.stack <= 10):
		return random.randi_range(actual_plaing_mob.damage_min, actual_plaing_mob.damage_max) * actual_plaing_mob.stack
	else:
		var damage = 0
		for i in range(actual_plaing_mob.stack):
			damage += random.randi_range(actual_plaing_mob.damage_min, actual_plaing_mob.damage_max)
		return damage

func _calculate_ai_attack_possibility():
	var possibilities: Array[float] = []
	var ranges: Array[bool] = []
	possibilities.resize(playerArmy.size())
	ranges.resize(playerArmy.size())
	for i in range(playerArmy.size()):
		ranges[i] = true if(battle_ground.has_range_to(playerArmy[i])) else false
		possibilities[i] = 1.3 if(ranges[i]) else 0.5
		var attack_value = _calculate_attack_value(playerArmy[i], actual_plaing_mob) - playerArmy[i].defense #uwzglęcnić bonus do defendu
		var counteratack_value = 0 if(!playerArmy[i].counterattack) else _calculate_attack_value(actual_plaing_mob, playerArmy[i]) - actual_plaing_mob.defense
		possibilities[i] *= 0.33 if(counteratack_value > actual_plaing_mob.hp_stack) else 2
		possibilities[i] *= (0.33*attack_value)
	
	if(has_no_chances(possibilities, ranges)):
		if(there_are_no_stronger_mobs() and random.randi_range(0,3) < 3):
			mob_defense()
			return
	
	var attackedMob = playerArmy[possibilities.find(possibilities.max)]
	var calculated_path = Array([], TYPE_VECTOR2I, "", null)
	
	if(!actual_plaing_mob.distant):
		calculated_path = battle_ground.trace_between(battle_ground.local_to_map(actual_plaing_mob.position),battle_ground.local_to_map(attackedMob.position), false)
		for cell in calculated_path.duplicate():
			if($Battleground/SelectLayer.get_used_cells().find(cell) == -1):
				calculated_path.erase(cell)
	elif(!battle_ground.are_next_to(battle_ground.local_to_map(actual_plaing_mob.position), battle_ground.local_to_map(attackedMob.position))):
		distant_attack(attackedMob)
		return
	
	if calculated_path.size() > 0:
		battle_ground.placeMobAt(actual_plaing_mob,calculated_path[-1])
	
	if(calculated_path.size() == 0 or battle_ground.are_next_to(calculated_path[-1], battle_ground.local_to_map(attackedMob.position))):
		target = attackedMob
	
	if(calculated_path.size() == 0):
		find_child("StateMachine").transition_to_state(BattleTurnState.ATTACK)
	else:
		calculated_path = battle_ground.map_to_local_array(calculated_path)
		actual_plaing_mob.walking_path = calculated_path

func has_no_chances(attack_possibilities: Array[float], ranges: Array[bool]) -> bool:
	var noChance = true
	for chance in attack_possibilities:
		if(chance > 0.0):
			noChance = false
	for range in ranges:
		if(!range):
			noChance = false
	return noChance

func there_are_no_stronger_mobs():
	var temp_mob = actual_plaing_mob
	var chances = []
	chances.resize(enemyArmy.size())
	for n in range(enemyArmy.size()):
		actual_plaing_mob = enemyArmy[n]
		
		var possibilities: Array[float] = []
		var ranges: Array[bool] = []
		possibilities.resize(playerArmy.size())
		ranges.resize(playerArmy.size())
		for i in range(playerArmy.size()):
			ranges[i] = true if(battle_ground.has_range_to(playerArmy[i])) else false
			possibilities[i] = 1.3 if(ranges[i]) else 0.5
			var attack_value = _calculate_attack_value(playerArmy[i], actual_plaing_mob) - playerArmy[i].defense #uwzglęcnić bonus do defendu
			var counteratack_value = 0 if(!playerArmy[i].counterattack) else _calculate_attack_value(actual_plaing_mob, playerArmy[i]) - actual_plaing_mob.defense
			possibilities[i] *= 0.33 if(counteratack_value > actual_plaing_mob.hp_stack) else 2
			possibilities[i] *= (0.33*attack_value)
		chances[n] = has_no_chances(possibilities, ranges)
	actual_plaing_mob = temp_mob
	for n in chances:
		if n:
			return false
	return true

func mob_wait():
	if(block_actions): return
	if(morale_round):
		morale_wait_queue.append(actual_plaing_mob)
	else:
		wait_queue.append(actual_plaing_mob)
	find_child("StateMachine").transition_to_state(BattleTurnState.SELECTED)

func mob_defense():
	def_anim.show_on_position(actual_plaing_mob.position)
	if(block_actions): return
	actual_plaing_mob.defense_boost = 1
	find_child("StateMachine").transition_to_state(BattleTurnState.SELECTED)

func try_to_retreat():
	block_actions = true
	surrender_popup.set_message("Czy na pewno chcesz uciec od walki?")
	surrender_popup.show_window()
	await surrender_popup.action
	block_actions = false

func try_to_surrender():
	block_actions = true
	retreat_popup.set_message("Aby się poddać uiść opłatę w wysokości "+str(army_value())+" sztuk złota")
	retreat_popup.show_window()
	await retreat_popup.action
	block_actions = false

func retreat():
	hero.army = []
	return_hero_to_castle.emit(hero)

func surrender():
	rebuild_hero_army()
	return_hero_to_castle.emit(hero)

func rebuild_hero_army():
	var new_army: Array[ArmyUnit] = []
	for i in range(playerArmy.size()):
		if(playerArmy[i].stack > 0):
			pass
			#TODO: ZRÓB COŚ Z TYM, chociaż może zadziała?
			var unit = ArmyUnit.new()
			unit.mob = playerArmy[i].mob_attributes
			unit.stack = playerArmy[i].stack
			new_army.append(unit)
			#new_army.append(ArmyUnit.new(playerArmy[i].new(), playerArmy[i].stack))
	hero.army = new_army.duplicate()

func army_value() -> int:
	var sum = 0
	for unit:ArmyUnit in hero.army:
		sum += unit.mob.cost * unit.stack
	return int(sum/2)

func set_battle(hero: Hero, oponent: Array[ArmyUnit]):
	var positions: Array
	var iterator = 0
	#var positions1 = [Vector2i(5,5),Vector2i(3,5),Vector2i(4,4),Vector2i(5,4)]
	positions = army_placing(hero.army)
	
	for army in [hero.army, oponent]:
		for unit: ArmyUnit in army:
			if unit.mob != null:
				#var mob_node = unit.mob.scene.instantiate()
				var mob_scene = load("res://scenes/units/Mob.tscn")
				var mob_node = mob_scene.instantiate()
				mob_node.mob_attributes = unit.mob
				mob_node.stack = unit.stack
				mobs_node.add_child(mob_node)
				mob_node.mob_play.connect(battle_ground.mobTurnListener)
				mob_node.mob_ended.connect(next_mob)
				mob_node.mob_info_show.connect(show_info_box)
				mob_node.mob_info_hide.connect(hide_info_box)
				if(army == hero.army):
					battle_ground.initialPlaceMob(mob_node, Vector2i(0,positions[iterator]-1))
					playerArmy.append(mob_node)
				else:
					battle_ground.initialPlaceMob(mob_node, Vector2i(14,positions[iterator]-1))
					mob_node.player = false
					mob_node.mob_play.connect(_calculate_ai_attack_possibility)
					mob_node.find_child("Sprite").flip_h = true
					mob_node.find_child("Stack").position.x = -mob_node.find_child("Stack").position.x - mob_node.find_child("Stack").size.x
					mob_node.mob_clicked.connect(attackMob)
					mob_node.hit_box_input.connect(set_cursor_to_sword)
					enemyArmy.append(mob_node)
				iterator+=1
		positions = army_placing(oponent)
		iterator = 0

func army_placing(army: Array[ArmyUnit]) -> Array[int]:
	if(!army.size() % 2):
		return [0,10,4,6,2,8,5]
	else:
		return [0,10,5,2,8,4,6]

func show_info_box(mob: Mob):
	var x_offset = 80 if(mob.player) else -100
	var y = mob.position.y/2 + 64
	var x = mob.position.x/2 + x_offset
	y = 0 if(y<0) else (470 if y > 470 else y)
	x = 0 if(x <0) else (950 if x > 950 else x)
	
	stats_window.set_window_position(Vector2(x, y))
	stats_window.pass_mob(mob)
	stats_window.set_visibility(true)

func hide_info_box():
	stats_window.set_visibility(false)

func set_cursor_to_sword(mob: Mob, part: Mob.Part):
	if(actual_plaing_mob.distant):
		var straight_distance = battle_ground.straight_distance_mobs(actual_plaing_mob, mob)
		if(straight_distance > 1 and straight_distance <= 10):
			battle_ground.change_cursor(load("res://assets/cursors/arrowWhol.png"))
			return
		elif(straight_distance > 10):
			battle_ground.change_cursor(load("res://assets/cursors/arrowBroke.png"))
			return
	if(battle_ground.has_range_on_side(mob, part)):
		var texture = AtlasTexture.new()
		texture.atlas = load("res://assets/cursors/swordCursor.png")
		match(part):
			Mob.Part.LU: texture.region = Rect2(0,0,32,32)
			Mob.Part.RU: texture.region = Rect2(32,0,32,32)
			Mob.Part.LM: texture.region = Rect2(64,0,32,32)
			Mob.Part.RM: texture.region = Rect2(96,0,32,32)
			Mob.Part.LD: texture.region = Rect2(128,0,32,32)
			Mob.Part.RD: texture.region = Rect2(160,0,32,32)
		battle_ground.change_cursor(texture)
