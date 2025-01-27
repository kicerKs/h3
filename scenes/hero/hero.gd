extends Node2D
class_name Hero

@export_group("Stats")
@export var _army: Array[ArmyUnit] = []

@export_group("Systems")
@export var attributes: HeroAttributes
@export var state_machine: StateMachine

# To wywal jak podłączysz już do funkcji
var luck = 0 
var morale = 0
var army: Array[ArmyUnit] = []

var current_path = null
var _movement: int

func subtract_movement(value):
	_movement -= value

func get_movement():
	return _movement

func get_luck():
	return clamp(luck + attributes.get_luck_modifier(), -3, 3)

func get_morale():
	return clamp(morale + attributes.get_leadership_modifier(), -3, 3)

func get_army():
	return _army

func recruit():
	TurnSystem.connect("new_day", send_estates)
	TurnSystem.connect("new_day", calculate_movement)
	#TODO: dodaj do gui

func calculate_movement():
	print("XD")
	var base = 1000 #TODO: Change to slowest creature in army
	_movement = int( base * attributes.get_logistics_modifier() )

# Skill-specific

func send_estates():
	Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, attributes.get_estates_modifier())
