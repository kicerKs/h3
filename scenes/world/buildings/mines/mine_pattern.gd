extends Node2D

@export var resource_type: String = ""
@export var production_rate: int = 0 # amount of resources each round
@export var appearance: Color = Color(0, 0, 0, 0)
@export var active_mine: bool = false

signal give_resources(resource_type: String, amount: int) 

func _ready() -> void:
	$ColorRect.color = appearance
	add_to_group("Mines")

func set_resource_type(new_resource_type: String) -> void:
	resource_type = new_resource_type
	
func set_production_rate(new_production_rate: int) -> void:
	production_rate = new_production_rate

func activate_mines() -> void:
	if not active_mine:
		active_mine = true

func _on_turn_system_new_day() -> void:
	if active_mine:
		print(self)
		Game.resources[resource_type] += production_rate
		#emit_signal("give_resources", resource_type, production_rate)

func _process(delta: float) -> void:
	pass
