extends Node

@export var tilemap: TileMapLayer
@export var line2d_green: Line2D
@export var line2d_red: Line2D

var astar_grid: AStarGrid2D

signal start(path)

var player: Hero
var calculated_path = null
var green_path = null
var red_path = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TurnSystem.connect("new_day", reset_path)
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2i(64, 64)
	astar_grid.update()
	var blocked_cells = tilemap.get_used_cells_by_id(0)
	for cell in blocked_cells:
		astar_grid.set_point_solid(cell, true)
	var road_cells = tilemap.get_used_cells_by_id(1)
	for cell in road_cells:
		astar_grid.set_point_weight_scale(cell, 0.5)
	var normal_cells = tilemap.get_used_cells_by_id(2)
	for cell in normal_cells:
		astar_grid.set_point_weight_scale(cell, 1)
	astar_grid.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_path():
	calculated_path = null
	green_path = null
	red_path = null
	line2d_green.points = []
	line2d_red.points = []

func start_pathfinding(h: Hero, movement: int):
	player = h
	var end_point = tilemap.local_to_map(tilemap.get_local_mouse_position())
	if astar_grid.is_in_bounds(end_point.x, end_point.y) and !astar_grid.is_point_solid(tilemap.local_to_map(tilemap.get_local_mouse_position())):
		var path = astar_grid.get_point_path(tilemap.local_to_map(player.position), tilemap.local_to_map(tilemap.get_local_mouse_position()))
		if calculated_path != path: # Pokaż ścieżkę, ale nie zaczynaj pathfindingu
			reset_path()
			calculated_path = path
			var line_path = []
			for vec in path:
				line_path.append(vec + Vector2(31,31))
			green_path = []
			red_path = []
			green_path.append(line_path[0])
			for vec in line_path.slice(1):
				if calculate_movement_cost(vec) <= movement:
					movement -= calculate_movement_cost(vec)
					green_path.append(vec)
				else:
					break;
			red_path = line_path.slice(max(len(green_path)-1, 0))
			line2d_green.points = green_path
			line2d_red.points = red_path
		else:
			var p = []
			for vector in green_path:
				p.append([vector - Vector2(31,31),calculate_movement_cost(vector)])
			if len(p) < 2:
				return null
			return p
	return null

func calculate_movement_cost(point):
	var pt = tilemap.local_to_map(point)
	match tilemap.get_cell_source_id(pt):
		1:
			return 50
		2:
			return 100
		_:
			return 9999

func pop_green_line_point():
	line2d_green.points = line2d_green.points.slice(1)

func set_green_line_to_hero(pos):
	line2d_green.points[0] = pos + Vector2(31,31)
