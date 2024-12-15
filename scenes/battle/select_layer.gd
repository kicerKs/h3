extends TileMapLayer

signal cell_clicked(Vector2i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_position_on_map = local_to_map(Vector2i(get_global_mouse_position().x, get_global_mouse_position().y - 96))
		var tileData = self.get_cell_tile_data(mouse_position_on_map)
		if(tileData != null):
			cell_clicked.emit(mouse_position_on_map)
