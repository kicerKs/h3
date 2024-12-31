class_name Battle extends Node

var playerArmy: Array[Mob] = []
var enemyArmy: Array[Mob] = []

var fight_sequence: Array[Mob] = []
var initial_queue: Array[Mob] = []
var morale_wait_queue: Array[Mob] = []
var wait_queue: Array[Mob] = []
var actual_plaing_mob: Mob
var _end
var random = RandomNumberGenerator.new()
var hero: Hero
var target: Mob

var controls: Node
var mobs_node: Node
var retreat_popup: PopupWindow
var surrender_popup: PopupWindow
var block_actions: bool

signal return_hero_to_castle(hero: Hero)
signal player_won
signal enemy_won

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mobs_node = $Mobs
	controls = $Controls
	retreat_popup = $RetreatPopup
	surrender_popup = $SurrenderPopup
	
	hero = Hero.new()
	hero.army = {
		Soldier.new(): 12,
		Sniper.new(): 5,
		Firebat.new(): 3,
		Tank.new(): 8,
	}
	var oponent = {
		Soldier.new(): 1,
		Sniper.new(): 1,
		Firebat.new(): 1,
		Marine.new(): 1,
	}
	
	add_obstacles()
	bound_control_buttons()
	set_battle(hero, oponent)
	fight_sequence.append_array(mobs_node.get_children())
	fight_sequence.sort_custom(mob_sort)
	
	#na koniec potrzebna mechanika walki na odległość

func bound_control_buttons():
	controls.wait_button_signal.connect(mob_wait)
	controls.defend_button_signal.connect(mob_defence)
	controls.retreat_button_signal.connect(try_to_retreat)
	controls.surrender_button_signal.connect(try_to_surrender)
	retreat_popup.approve_button_down.connect(retreat)

func add_obstacles():
	var obstacles = {
		Vector2i(6,6): 1,
		Vector2i(5,6): 1,
		Vector2i(4,6): 1,
		Vector2i(7,6): 1,
		Vector2i(6,5): 1,
		Vector2i(6,7): 1,
		}
	for cell in obstacles.keys():
		$Battleground.put_obstacle(cell, obstacles[cell])

func mob_sort(mob1: Mob, mob2: Mob):
	if(mob1.get_speed() > mob2.get_speed()):
		return true
	return false

func next_mob():
	if initial_queue.size() == 0 and morale_wait_queue.size() == 0 and wait_queue.size() == 0:
		initial_queue = fight_sequence.duplicate(true)
		for mob: Mob in initial_queue:
			mob.counterattack = true
			mob.defence_boost = false
	
	erase_dead_mobs()
	check_win()
	
	if initial_queue.size() != 0:
		actual_plaing_mob = initial_queue.pop_front()
	elif morale_wait_queue.size() != 0:
		actual_plaing_mob = morale_wait_queue.pop_front()
	elif wait_queue.size() != 0:
		actual_plaing_mob = wait_queue.pop_front()
	
	if actual_plaing_mob.player :
		controls.unlock_all_buttons()
	else:
		controls.lock_all_buttons()
	if initial_queue.size() == 0:
		controls.lock_wait_button()
		
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
				$Battleground.set_enable($Battleground.local_to_map(mob.position))
		else:
			new_sequence.append(mob)
	fight_sequence = new_sequence

func check_win():
	var player_win = true
	for mob in enemyArmy:
		if(mob.stack > 0):
			player_win = false
	if(player_win):
		player_won.emit()
		return
		
	var enemy_win = true
	for mob in playerArmy:
		if(mob.stack > 0):
			enemy_win = false
	if(enemy_win):
		enemy_won.emit()

func meleAttackMob(mob: Mob, side: Mob.Part):
	if(block_actions): return
	if(!$Battleground.has_range_on_side(mob, side) or 
		(playerArmy.find(actual_plaing_mob)>=0 and playerArmy.find(mob)>=0)):
		return 
	
	$Battleground.placeMobAt(actual_plaing_mob,$Battleground.cell_on_side(mob,side))
	target = mob
	find_child("StateMachine").transition_to_state(BattleTurnState.ATTACK)

func fight():
	var defence_attacked = target.defence + (0 if !target.player else hero.defense)
	var defence_attacker = actual_plaing_mob.defence + (0 if !actual_plaing_mob.player else hero.defense)
	target.hp_stack -= (_calculate_attack_value(actual_plaing_mob, target) - defence_attacked * (1.2 if(target.defence_boost)else 1))
	if(target.counterattack):
		actual_plaing_mob.hp_stack -= (_calculate_attack_value(target, actual_plaing_mob) - defence_attacker * (1.2 if(actual_plaing_mob.defence_boost)else 1))
		target.counterattack = false
	target = null

func _calculate_attack_value(attacker: Mob, defender: Mob, distance_attack: bool = false) -> int:
	var A = attacker.attack + (0 if !attacker.player else hero.attack)
	var D = defender.defence + (0 if !defender.player else hero.defense)
	var luck = 0 if(!attacker.player) else hero.luck
	
	var i1 = 0 if(A>=D) else 0.05*(A-D)
	var R1 = 0 if(D>=A) else 0.025*(D-A)
	var R5 = 0 #TODO dla dystansowych 
	var R6 = 0 #TODO dla dystansowych 
	return roundi(_conut_base_attack() * (1+i1+luck) * (1-R1) * (1-R5) * (1-R6))

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
		ranges[i] = true if($Battleground.has_range_to(playerArmy[i])) else false
		possibilities[i] = 1 if(ranges[i]) else 0.5
		var attack_value = _calculate_attack_value(playerArmy[i], actual_plaing_mob) - playerArmy[i].defence #uwzglęcnić bonus do defendu
		var counteratack_value = 0 if(!playerArmy[i].counterattack) else _calculate_attack_value(actual_plaing_mob, playerArmy[i]) - actual_plaing_mob.defence
		possibilities[i] *= 0.33 if(counteratack_value > actual_plaing_mob.hp_stack) else 2
		possibilities[i] *= (0.33*attack_value)
	
	if(no_chances(possibilities, ranges)):
		mob_defence()
		return
	
	var attackedMob = playerArmy[possibilities.find(possibilities.max)]
	var calculated_path = $Battleground.trace_between($Battleground.local_to_map(actual_plaing_mob.position),$Battleground.local_to_map(attackedMob.position), false)

	for cell in calculated_path.duplicate():
		if($Battleground/SelectLayer.get_used_cells().find(cell) == -1):
			calculated_path.erase(cell)
	if calculated_path.size() > 0:
		$Battleground.placeMobAt(actual_plaing_mob,calculated_path[-1])
	
	if(calculated_path.size() == 0 or $Battleground.are_next_to(calculated_path[-1], $Battleground.local_to_map(actual_plaing_mob.position))):
		target = attackedMob
		find_child("StateMachine").transition_to_state(BattleTurnState.ATTACK)
	
	var path = $Battleground.map_to_local_array(calculated_path)
	actual_plaing_mob.walking_path = calculated_path

func no_chances(array: Array[float], ranges: Array[bool]) -> bool:
	var noChance = true
	for chance in array:
		if(chance > 0.0):
			noChance = false
	for range in ranges:
		if(range):
			noChance = false
	return noChance

func mob_wait():
	#TODO: uwzględnić tutaj morale
	wait_queue.append(actual_plaing_mob)
	find_child("StateMachine").transition_to_state(BattleTurnState.SELECTED)

func mob_defence():
	actual_plaing_mob.defence_boost = 1
	find_child("StateMachine").transition_to_state(BattleTurnState.SELECTED)

func try_to_retreat():
	block_actions = true
	retreat_popup.set_message("Aby wycofać się uiść opłatę w wysokości "+str(army_value())+" sztuk złota")
	retreat_popup.show_window()
	await retreat_popup.action
	block_actions = false

func try_to_surrender():
	block_actions = true
	surrender_popup.set_message("Czy na pewno chcesz poddać walkę?")
	surrender_popup.show_window()
	await surrender_popup.action
	block_actions = false

func retreat():
	var new_army = {}
	for i in range(playerArmy.size()):
		if(playerArmy[i].stack > 0):
			new_army[hero.army.keys()[i]] = playerArmy[i].stack
	hero.army = new_army.duplicate()
	
	return_hero_to_castle.emit(hero)

func surrender():
	hero.army = {}
	return_hero_to_castle.emit(hero)

func army_value() -> int:
	var sum = 0
	for mob:Mob in hero.army.keys():
		sum += mob.cost * hero.army[mob]
	return int(sum/2)

func set_battle(hero: Hero, oponent: Dictionary):
	var positions: Array
	#var positions2: Array
	var iterator = 0
	if(!hero.army.keys().size() % 2):
		positions = [0,10,4,6,2,8,5]
		#positions = [ Vector2i(0,2),Vector2i(7,6),Vector2i(6,7),Vector2i(7,8)]
		#positions2 = [ Vector2i(6,8),Vector2i(5,7),Vector2i(6,6),Vector2i(7,7)]
	else:
		positions = [0,10,5,2,8,4,6]
		
	for mob: Mob in hero.army.keys():
		var mob_node = mob.scene.instantiate()
		mob_node.stack = hero.army[mob]
		mobs_node.add_child(mob_node)
		$Battleground.initialPlaceMob(mob_node, Vector2i(0,positions[iterator]-1))# positions[iterator])#
		mob_node.mob_play.connect($Battleground.mobTurnListener)
		mob_node.mob_ended.connect(next_mob)
		playerArmy.append(mob_node)
		iterator+=1
	
	iterator = 0
	for mob: Mob in oponent.keys():
		var mob_node: Mob = mob.scene.instantiate()
		mob_node.stack = oponent[mob]
		mobs_node.add_child(mob_node)
		mob_node.player = false
		mob_node.get_child(0).flip_h = true
		mob_node.find_child("Stack").position.x = -mob_node.find_child("Stack").position.x - mob_node.find_child("Stack").size.x
		$Battleground.initialPlaceMob(mob_node, Vector2i(14,positions[iterator]-1))# positions2[iterator])#
		mob_node.mob_play.connect($Battleground.mobTurnListener)
		mob_node.mob_play.connect(_calculate_ai_attack_possibility)
		mob_node.mob_ended.connect(next_mob)
		mob_node.mob_clicked.connect(meleAttackMob)
		enemyArmy.append(mob_node)
		iterator+=1
	
