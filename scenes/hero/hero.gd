extends Node2D
class_name Hero

@export_group("Stats")
@export var _army: Array[ArmyUnit] = []
@export_group("Systems")
@export var attributes: HeroAttributes

@onready var state_machine: StateMachine = $StateMachine

signal max_movement_changed(value)
signal movement_changed(value)
signal army_changed

var inside_something = false
signal interact

var _luck = 0
var _morale = 0

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

var current_path = null
var _movement: int

func _ready():
	add_to_group("Heroes")

func subtract_movement(value):
	_movement -= value
	movement_changed.emit(_movement)

func get_movement():
	return _movement

func get_luck():
	return clamp(_luck + attributes.get_luck_modifier(), 0, 3)

func get_morale():
	return clamp(_morale + attributes.get_leadership_modifier(), -3, 3)

func get_army():
	if len(_army) > 7:
		_army = _army.slice(0, 6)
	else:
		while len(_army) < 7:
			_army.append(ArmyUnit.nowy(null, -1))
	return _army

func swap_units(i, j):
	var t = _army[i]
	_army[i] = _army[j]
	_army[j] = t
	army_changed.emit()

func recruit(pos):
	self.global_position = pos
	TurnSystem.connect("new_day", send_estates)
	TurnSystem.connect("new_day", calculate_movement)
	state_machine.transition_to_state("Selected")
	calculate_movement()

func dismiss():
	TurnSystem.disconnect("new_day", send_estates)
	TurnSystem.disconnect("new_day", calculate_movement)
	state_machine.transition_to_state("Inactive")

func calculate_movement():
	var base = 1000 #TODO: Change to slowest creature in army
	_movement = int( base * attributes.get_logistics_modifier() )
	max_movement_changed.emit(_movement)

# Skill-specific

func send_estates():
	Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, attributes.get_estates_modifier())
