extends Node2D
class_name Hero

@export_group("Stats")
@export var attack: int
@export var defense: int
@export var _luck = 0
@export var _morale = 0
@export var _army: Array[ArmyUnit] = []

@export_group("Systems")
@export var Skills: HeroSkills
@export var state_machine: StateMachine

# To wywal jak podłączysz już do funkcji
var luck = 0 
var morale = 0
var army: Array[ArmyUnit] = []

var current_path = null

func get_luck():
	return clamp(luck + Skills.get_luck_modifier(), -3, 3)

func get_morale():
	return clamp(morale + Skills.get_leadership_modifier(), -3, 3)

func get_army():
	return _army

func recruit():
	TurnSystem.connect("new_day", send_estates)
	#TODO: dodaj do gui

# Skill-specific

func send_estates():
	Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, Skills.get_estates_modifier())
