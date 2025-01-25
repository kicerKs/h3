class_name Battleground extends Node2D

var mapLayer : TileMapLayer
var selectLayer : TileMapLayer
var takenSpots : Array[Vector2i] = []
var map_rect = Rect2i(0,-1, 15, 11)
var tile_size = 128

var hermesBoots = load("res://assets/cursors/bootsCursor.png")
var forbidden = load("res://assets/cursors/forbidden.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selectLayer = get_node("SelectLayer")
	mapLayer = get_node("TileMapLayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(selectLayer.get_used_cells().find(local_to_map(Vector2i(get_global_mouse_position().x, get_global_mouse_position().y - 96)))>=0):
		change_cursor(hermesBoots)
	elif(mapLayer.get_used_cells().find(local_to_map(Vector2i(get_global_mouse_position().x, get_global_mouse_position().y - 96)))>=0):
		change_cursor(forbidden)
	else:
		change_cursor(null)

func change_cursor(cursor: Texture2D):
	Input.set_custom_mouse_cursor(cursor,Input.CURSOR_ARROW,Vector2(16,16))

func local_to_map(local: Vector2i):
	return mapLayer.local_to_map(local)

func map_to_local(map: Vector2i):
	return mapLayer.map_to_local(map)

func local_to_map_array(local: Array) -> Array[Vector2i]:
	for x in range(local.size()):
		local[x] = Vector2i(mapLayer.local_to_map(local[x]))
	return local

func map_to_local_array(array: Array) -> Array[Vector2i]:
	var map = array.duplicate(true)
	for x in range(map.size()):
		map[x] = Vector2i(mapLayer.map_to_local(map[x]))
	return map

func is_taken(cell: Vector2i):
	return true if(takenSpots.find(cell) >= 0) else false

func set_enable(cell: Vector2i):
	takenSpots.erase(cell)

func clear_fields():
	takenSpots = []

func put_obstacle(cell: Vector2i, type: int):
	if type > 1: type = 1
	takenSpots.append(cell)
	var obstacle = Sprite2D.new()
	obstacle.texture = load("res://assets/rock.png")
	obstacle.position = map_to_local(cell)
	obstacle.position.y = obstacle.position.y + 64
	find_child("Obstacles").add_child(obstacle)

func are_next_to(source:Vector2i, target: Vector2i) -> bool:
	return selectLayer.get_surrounding_cells(source).find(target) >= 0

func has_range_to(attacked_mob: Mob) -> bool:
	for cell in selectLayer.get_surrounding_cells(local_to_map(attacked_mob.position)):
		if(selectLayer.get_used_cells().find(cell) >= 0):
			return true
	return false

func has_range_on_side(attacked_mob: Mob, side: Mob.Part) -> bool:
	var cell = cell_on_side(attacked_mob, side)
	return cell != Vector2i(-10,-10) and (selectLayer.get_used_cells().find(cell) >= 0 or cell == local_to_map(get_parent().actual_plaing_mob.position))

func cell_on_side(attacked_mob: Mob, side: Mob.Part) -> Vector2i:
	var position_next_to = Vector2i(-10,-10)
	var offset = 1 - abs(selectLayer.local_to_map(attacked_mob.position).y % 2)
	match side:
		Mob.Part.LU:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x-offset, selectLayer.local_to_map(attacked_mob.position).y-1)
		Mob.Part.RU:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x+1-offset, selectLayer.local_to_map(attacked_mob.position).y-1)
		Mob.Part.LM:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x-1, selectLayer.local_to_map(attacked_mob.position).y)
		Mob.Part.RM:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x+1, selectLayer.local_to_map(attacked_mob.position).y)
		Mob.Part.LD:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x-offset, selectLayer.local_to_map(attacked_mob.position).y+1)
		Mob.Part.RD:
			position_next_to = Vector2i(selectLayer.local_to_map(attacked_mob.position).x+1-offset, selectLayer.local_to_map(attacked_mob.position).y+1)
	
	return position_next_to

func moveActualTo(newPlace: Vector2i):
	if(get_parent().actual_plaing_mob.player and !get_parent().block_actions):
		placeMobAt(get_parent().actual_plaing_mob, newPlace)

func placeMobAt(mob: Mob, place: Vector2i):	
	var path = map_to_local_array(trace_between(mapLayer.local_to_map(mob.global_position), place))
	mob.walking_path = path
	move_taken_spot(mapLayer.local_to_map(mob.position), place)

func move_taken_spot(from: Vector2i, to: Vector2i):
	takenSpots.erase(from)
	takenSpots.append(to)

func trace_between(from: Vector2i, to: Vector2i, ignore_target_solid: bool = true) -> Array:
	var astar = AStarGrid2D.new()
	astar.region = map_rect
	astar.cell_size = mapLayer.tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	
	for cell in takenSpots:
		if !(cell == from or (cell == to and !ignore_target_solid)):
			astar.set_point_solid(cell)
	
	return astar.get_id_path(from,to)

func straight_distance(from: Vector2i, to: Vector2i) -> int:
	return round(from.distance_to(to))

func straight_distance_mobs(fromMob: Mob, toMob: Mob) -> int:
	return straight_distance(local_to_map(fromMob.position), local_to_map(toMob.position))

func initialPlaceMob(mob: Mob, place: Vector2i):
	mob.position = Vector2i(mapLayer.map_to_local(place).x, mapLayer.map_to_local(place).y + 40)
	takenSpots.append(mapLayer.local_to_map(mob.position))

func mobTurnListener()->void:
	drawRange()

func drawRange()->void:
	selectLayer.clear()
	if(get_parent().actual_plaing_mob != null):
		for n in range(-get_parent().actual_plaing_mob.speed,get_parent().actual_plaing_mob.speed+1):
			if(int(get_parent().actual_plaing_mob.position.y/96) % 2 == 0):
				for m in range(-get_parent().actual_plaing_mob.speed + abs(n/2+(n%2)),get_parent().actual_plaing_mob.speed - abs(n/2) + 1):
					if(mapLayer.get_cell_source_id(Vector2i(mapLayer.local_to_map(get_parent().actual_plaing_mob.position).x+m, mapLayer.local_to_map(get_parent().actual_plaing_mob.position).y+n))>=0):
						selectLayer.set_cell(Vector2i(mapLayer.local_to_map(get_parent().actual_plaing_mob.position).x+m, mapLayer.local_to_map(get_parent().actual_plaing_mob.position).y+n), 0, Vector2i(1,0))
			else:
				for m in range(-get_parent().actual_plaing_mob.speed + abs(n/2),get_parent().actual_plaing_mob.speed - abs(n/2+(n%2)) + 1):
					if(mapLayer.get_cell_source_id(Vector2i(mapLayer.local_to_map(get_parent().actual_plaing_mob.position).x+m, mapLayer.local_to_map(get_parent().actual_plaing_mob.position).y+n))>=0):
						selectLayer.set_cell(Vector2i(mapLayer.local_to_map(get_parent().actual_plaing_mob.position).x+m, mapLayer.local_to_map(get_parent().actual_plaing_mob.position).y+n), 0, Vector2i(1,0))
		excludeTakenSpots()
		if(!get_parent().actual_plaing_mob.flying):
			cutSpotsWithoutConnectionWith(mapLayer.local_to_map(get_parent().actual_plaing_mob.position))

func excludeTakenSpots():
	for spot in takenSpots:
		selectLayer.erase_cell(spot)

func cutSpotsWithoutConnectionWith(vector: Vector2i):
	for cell in selectLayer.get_used_cells():
		var path_size = trace_between(vector, cell).size()
		if(path_size == 0 or path_size - 1 > get_parent().actual_plaing_mob.speed):
			selectLayer.erase_cell(cell)
