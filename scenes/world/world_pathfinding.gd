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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("mouse_click_left"):
		#player.start_moving(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
		#print(astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position())))
