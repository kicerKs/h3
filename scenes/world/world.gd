extends Node2D

var resources = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rec = $TileMapLayer.get_used_rect()
	var off = Vector2i(rec.size.x*64, rec.size.y*64)
	print(off)
	$MainCamera.limit_top = 0
	$MainCamera.limit_bottom = off.y
	$MainCamera.limit_left = 0
	$MainCamera.limit_right = off.x
	
	#for mine in get_tree().get_call_group("Mines"):
	for mine in get_tree().get_nodes_in_group("Mines"):
		get_node("/root/Main/TurnSystem").connect("new_day", mine._on_turn_system_new_day)
		#print("Łączę kopalnię: ", mine.name)
		#mine.connect("give_resources", self, "_on_mine_produce") 

#func _on_mine_produce(resource_type: String, amount: int) -> void:
	#if resource_type in resources:
		#resources[resource_type] += amount
	#else:
		#resources[resource_type] = amount
	#print("Added: ", amount, resource_type, ", total: ", resources[resource_type])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _unhandled_input(event: InputEvent) -> void:
#	if Input.is_action_just_pressed("mouse_click_left"):
#		$Pathfinding.start_pathfinding()
