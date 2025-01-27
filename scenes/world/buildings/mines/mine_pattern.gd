extends Node2D

@export var resource_type: GameResources.ResourceTypes
@export var appearance: Color = Color(0, 0, 0, 0)

var production_rate: int = 0 # amount of resources each round
var active_mine: bool = true

func _ready() -> void:
	$ColorRect.color = appearance
	add_to_group("Mines")
	TurnSystem.connect("new_day", _on_turn_system_new_day)
	
	match resource_type:
		GameResources.ResourceTypes.WOOD, GameResources.ResourceTypes.METAL:
			production_rate = 2
		GameResources.ResourceTypes.CREDITS:
			production_rate = 1000
		GameResources.ResourceTypes.PSI_CRYSTAL, GameResources.ResourceTypes.COAL, GameResources.ResourceTypes.GASOLINE, GameResources.ResourceTypes.SILICON:
			production_rate = 1

func activate_mines() -> void:
	if not active_mine:
		active_mine = true

func _on_turn_system_new_day() -> void:
	if active_mine:
		Game.Resources.add_resource(resource_type, production_rate)
