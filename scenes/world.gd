extends Node2D

@onready var tilemap = $TileMapLayer
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rec = $TileMapLayer.get_used_rect()
	var off = Vector2i(rec.size.x*64, rec.size.y*64)
	print(off)
	$MainCamera.limit_top = 0
	$MainCamera.limit_bottom = off.y
	$MainCamera.limit_left = 0
	$MainCamera.limit_right = off.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click_left"):
		# print(tilemap.local_to_map(tilemap.get_local_mouse_position()))
		# player.position = tilemap.local_to_map(tilemap.get_local_mouse_position())*64
		var astar_grid = AStarGrid2D.new()
		astar_grid.region = tilemap.get_used_rect()
		astar_grid.cell_size = Vector2i(64, 64)
		astar_grid.update()
		player.start_moving(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
		print(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
