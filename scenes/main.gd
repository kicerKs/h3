extends Node

var current_day: int = 1
var mines: Array

func _ready() -> void:
	mines = get_tree().get_nodes_in_group("Mines")
	
	#var turn_system = get_parent().get_node("TurnSystem")
	#var turn_system = get_node("/root/global/turn_system")
	#turn_system.connect("update_turn", self, "_on_turn_system_update_turn")
	#turn_system.connect("new_day", self, "_on_new_day")
	#get_parent().get_node("TurnSystem")
	
	create_gold_mine(Vector2(100, 100))
	create_gold_mine(Vector2(200, 200))
	
func create_gold_mine(position: Vector2) -> void:
	var gold_mine_scene = preload("res://scenes/world/buildings/mines/minePattern.tscn")
	var gold_mine = gold_mine_scene.instantiate() 
	gold_mine.set_resource_type("Gold")
	gold_mine.set_production_rate(1000)
	gold_mine.appearance = Color(1, 1, 0, 1)
	gold_mine.position = position
	add_child(gold_mine)
	mines.append(gold_mine)
			
func _on_turn_system_update_turn(day: int, week: int, month: int) -> void:
	if day != current_day:
		current_day = day
		update_mines()

func _on_new_day() -> void:
	update_mines()

func update_mines() -> void:
	for mine in mines:
		var produced_resource = mine.update_day(current_day)
		if produced_resource.size() > 0:
			update_player_resources(produced_resource)

func update_player_resources(produced_resource: Dictionary) -> void:
	print("Zasoby gracza: %d jednostek %s" % [produced_resource["amount"], produced_resource["type"]])

func _process(delta: float) -> void:
	pass
