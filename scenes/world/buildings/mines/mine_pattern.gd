extends Node2D

@export var resource_type: String = ""
@export var production_rate: int = 0 # amount of resources each round
@export var appearance: Color = Color(0, 0, 0, 0)

var current_day: int = 0

func _ready() -> void:
	$ColorRect.color = appearance
	
func update_day(new_day: int) -> Dictionary:
	if new_day != current_day:
		current_day = new_day
		return produce_resources()
	return {}

func produce_resources() -> Dictionary:
	var produced_resource = {
		"type": resource_type,
		"amount": production_rate
	}
	return produced_resource
	
func set_resource_type(new_resource_type: String) -> void:
	resource_type = new_resource_type
	
func set_production_rate(new_production_rate: int) -> void:
	production_rate = new_production_rate

func _process(delta: float) -> void:
	pass
