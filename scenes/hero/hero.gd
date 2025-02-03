extends Node2D
class_name Hero

@export_group("Stats")
@export var _army: Array[ArmyUnit] = []
@export_group("Systems")
@export var attributes: HeroAttributes

@onready var tilemap: TileMapLayer = get_node("/root/Main/World/MapMoving")
var previous_cell_id
@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite2D

signal max_movement_changed(value)
signal movement_changed(value)
signal army_changed

var inside_something = false
signal interact
signal interact_forced

var _luck = 0
var _morale = 0

var luck_bonus = -1
var morale_bonus = -99

var luck:
	get():
		return get_luck()
	set(value):
		_luck = clamp(value, 0, 3)
var morale:
	get():
		return get_morale()
	set(value):
		_morale = clamp(value, -3, 3)
var army: Array[ArmyUnit]:
	get():
		return get_army()

var level = 1
var experience: int = 0
var xp_threshold: int = 1000
signal levelup(hero: Hero, isDef: bool, selection)

var current_path = null
var _movement: int

func _ready():
	add_to_group("Heroes")
	var my_cell = tilemap.local_to_map(global_position)
	previous_cell_id = tilemap.get_cell_source_id(my_cell)

func subtract_movement(value):
	_movement -= value
	movement_changed.emit(_movement)

func calculate_movement():
	var base = 1000 #TODO: Change to slowest creature in army
	_movement = int( base * attributes.get_logistics_modifier() )
	max_movement_changed.emit(_movement)

func get_movement():
	return _movement

func get_luck():
	return clamp(_luck + clamp(luck_bonus, 0, 10) + attributes.get_luck_modifier(), 0, 3)

func get_morale():
	if morale_bonus != -99:
		return clamp(_morale + clamp(morale_bonus, -10, 10) + attributes.get_leadership_modifier(), -3, 3)
	else:
		return clamp(_morale +  attributes.get_leadership_modifier(), -3, 3)

func reset_luck_morale_bonuses():
	luck_bonus = -1
	morale_bonus = -99

func get_army():
	if len(_army) > 7:
		_army = _army.slice(0, 6)
	else:
		while len(_army) < 7:
			_army.append(ArmyUnit.nowy(null, -1))
	return _army

func add_units_to_army(unit: MobAttributes, number: int):
	for i in _army.size():
		if _army[i].mob == unit:
			_army[i].stack += number
			army_changed.emit()
			return
	for i in _army.size():
		if _army[i].mob == null:
			_army[i] = ArmyUnit.nowy(unit, number)
			army_changed.emit()
			return
	if len(_army) < 7:
		_army.append(ArmyUnit.nowy(unit, number))
		army_changed.emit()

func swap_units(i, j):
	var t = _army[i]
	_army[i] = _army[j]
	_army[j] = t
	army_changed.emit()

# Add / Remove hero

func recruit(pos):
	self.global_position = pos
	var my_cell = tilemap.local_to_map(global_position)
	previous_cell_id = tilemap.get_cell_source_id(my_cell)
	TurnSystem.connect("new_day", send_estates)
	TurnSystem.connect("new_day", calculate_movement)
	state_machine.transition_to_state("Selected")
	calculate_movement()

func dismiss():
	TurnSystem.disconnect("new_day", send_estates)
	TurnSystem.disconnect("new_day", calculate_movement)
	state_machine.transition_to_state("Inactive")

# Levelling

func add_xp(num):
	experience += num
	if experience >= xp_threshold:
		level += 1
		xp_threshold = xp_threshold * 2
		levelup.emit(self, attributes.get_level_up_random_skills())

func finalize_levelup(isDef: bool, skill: HeroSkill.Skills):
	if isDef:
		attributes.defense += 1
	else:
		attributes.attack += 1
	attributes.add_skill(skill)
	print(attributes.get_skills())

# Skill-specific

func send_estates():
	Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, attributes.get_estates_modifier())
