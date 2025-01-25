extends Node

@export var tilemap: TileMapLayer
@export var player: Hero

var astar_grid: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2i(64, 64)
	astar_grid.update()
	var blocked_cells = tilemap.get_used_cells_by_id(0)
	for cell in blocked_cells:
		astar_grid.set_point_solid(cell, true)
	var road_cells = tilemap.get_used_cells_by_id(1)
	print("ROADS")
	print(road_cells)
	for cell in road_cells:
		astar_grid.set_point_weight_scale(cell, 0.5)
	var normal_cells = tilemap.get_used_cells_by_id(2)
	print("NORMALS")
	print(normal_cells)
	for cell in normal_cells:
		astar_grid.set_point_weight_scale(cell, 1)
	astar_grid.update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click_left") and !astar_grid.is_point_solid(tilemap.local_to_map(tilemap.get_local_mouse_position())):
		player.start_moving(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
		print(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
