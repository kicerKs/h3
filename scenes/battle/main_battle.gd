extends Node

var playerArmy: Array[Mob] = []
var enemyArmy: Array[Mob] = []

var fight_sequence: Array[Mob] = []
var initial_queue: Array[Mob] = []
var morale_wait_queue: Array[Mob] = []
var wait_queue: Array[Mob] = []
var actual_plaing_mob: Mob
var mobs_node: Node
var _end
var random = RandomNumberGenerator.new()
var hero: Hero

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mobs_node = $Mobs
	
	hero = Hero.new()
	hero.army = {
		Soldier.new(): 12,
		Sniper.new(): 5,
		Firebat.new(): 3,
		Tank.new(): 8,
	}
	var oponent = {
		Soldier.new(): 10,
		Sniper.new(): 1,
		Firebat.new(): 10,
		Marine.new(): 18,
	}
	bound_control_buttons()
	set_battle(hero, oponent)
	fight_sequence.append_array(mobs_node.get_children())
	fight_sequence.sort_custom(mob_sort)
	
	next_mob()

	#na koniec potrzebna mechanika walki na odległość

func bound_control_buttons():
	find_child("Controls").wait_button_signal.connect(mob_wait)
	find_child("Controls").defend_button_signal.connect(mob_defence)

func mob_sort(mob1: Mob, mob2: Mob):
	if(mob1.get_speed() > mob2.get_speed()):
		return true
	return false

func next_mob():
	if initial_queue.size() == 0 and morale_wait_queue.size() == 0 and wait_queue.size() == 0:
		_end = true
		initial_queue = fight_sequence.duplicate(true)
		for mob: Mob in initial_queue:
			mob.counterattack = true
	
	if initial_queue.size() != 0:
		actual_plaing_mob = initial_queue.pop_front()
	elif morale_wait_queue.size() != 0:
		actual_plaing_mob = morale_wait_queue.pop_front()
	elif wait_queue.size() != 0:
		actual_plaing_mob = wait_queue.pop_front()
	
	actual_plaing_mob.find_child("StateMachine").transition_to_state(MobState.SELECTED)

func meleAttackMob(mob: Mob, side: Mob.Part):
	if(!$Battleground.has_range_to(mob, side) or 
		(playerArmy.find(actual_plaing_mob)>=0 and playerArmy.find(mob)>=0)):
		return 
	
	actual_plaing_mob.find_child("StateMachine").transition_to_state(MobState.ATTACK)
	actual_plaing_mob.walking_path = $Battleground.map_to_local_array(
		$Battleground.trace_between($Battleground.local_to_map(actual_plaing_mob.position),$Battleground.cell_on_side(mob,side), false))
	
	#fight(actual_plaing_mob, mob)

func fight(attacker:Mob, mobAttacked: Mob):
	var defence_attacked = mobAttacked.defence + (0 if !mobAttacked.player else hero.defense)
	var defence_attacker = attacker.defence + (0 if !attacker.player else hero.defense)
	mobAttacked.hp_stack -= (_calculate_attack_value(attacker, mobAttacked) - defence_attacked)
	if(mobAttacked.counterattack):
		attacker.hp_stack -= (_calculate_attack_value(mobAttacked, attacker) - defence_attacker)
		mobAttacked.counterattack = false

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
	possibilities.resize(playerArmy.size())
	for i in range(playerArmy.size()):
		possibilities[i] = 1 if($Battleground.has_range(actual_plaing_mob,playerArmy[i])) else 0.5
		var attack_value = _calculate_attack_value(playerArmy[i], actual_plaing_mob) - playerArmy[i].defence #uwzglęcnić bonus do defendu
		var counteratack_value = 0 if(!playerArmy[i].counterattack) else _calculate_attack_value(actual_plaing_mob, playerArmy[i]) - actual_plaing_mob.defence
		possibilities[i] *= 0.33 if(counteratack_value > actual_plaing_mob.hp_stack) else 2
		possibilities[i] *= (0.33*attack_value)
	
	var attackedMob = playerArmy[possibilities.find(possibilities.max)]
	var calculated_path = $Battleground.trace_between($Battleground.local_to_map(actual_plaing_mob.position),$Battleground.local_to_map(attackedMob.position), true)

	for cell in calculated_path.duplicate():
		if($Battleground/SelectLayer.get_used_cells().find(cell) == -1):
			calculated_path.erase(cell)
	if calculated_path.size() > 0:
		$Battleground.move_taken_spot($Battleground.local_to_map(actual_plaing_mob.position), calculated_path[-1])
	
	var path = $Battleground.map_to_local_array(calculated_path)
	actual_plaing_mob.walking_path = calculated_path

func mob_wait():
	#TODO: uwzględnić tutaj morale
	wait_queue.append(actual_plaing_mob)
	actual_plaing_mob.find_child("StateMachine").transition_to_state(MobState.IDLE)

func mob_defence():
	actual_plaing_mob.defence_boost = 1
	actual_plaing_mob.find_child("StateMachine").transition_to_state(MobState.IDLE)

func autoplay(mob: Mob):
	_calculate_ai_attack_possibility()

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
		var mob_node = Tank.new().scene.instantiate()#mob.scene.instantiate()
		mob_node.stack = hero.army[mob]
		mobs_node.add_child(mob_node)
		$Battleground.initialPlaceMob(mob_node, Vector2i(6,positions[iterator]-1))# positions[iterator])#
		mob_node.find_child("Selected").mob_selected.connect($Battleground.mobTurnListener)
		mob_node.mob_ended.connect(next_mob)
		#mob_node.mob_clicked.connect(meleAttackMob)
		playerArmy.append(mob_node)
		iterator+=1
	
	iterator = 0
	for mob: Mob in oponent.keys():
		var mob_node: Mob = Tank.new().scene.instantiate()#mob.scene.instantiate()
		mob_node.stack = oponent[mob]
		mobs_node.add_child(mob_node)
		mob_node.player = false
		mob_node.get_child(0).flip_h = true
		mob_node.find_child("Stack").position.x = -mob_node.find_child("Stack").position.x - mob_node.find_child("Stack").size.x
		$Battleground.initialPlaceMob(mob_node, Vector2i(14,positions[iterator]-1))# positions2[iterator])#
		mob_node.find_child("Selected").mob_selected.connect($Battleground.mobTurnListener)
		mob_node.find_child("Selected").mob_selected.connect(autoplay)
		mob_node.mob_ended.connect(next_mob)
		mob_node.mob_clicked.connect(meleAttackMob)
		enemyArmy.append(mob_node)
		iterator+=1
	
