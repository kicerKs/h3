class_name Battleground extends Node2D

var mapLayer : TileMapLayer
var selectLayer : TileMapLayer
var selectedMob : Mob
var takenSpots : Array[Vector2i] = []
var map_rect = Rect2i(0,-1, 15, 11)
var tile_size = 128

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selectLayer = get_node("SelectLayer")
	mapLayer = get_node("TileMapLayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass

func local_to_map(local: Vector2i):
	return mapLayer.local_to_map(local)

func map_to_local(map: Vector2i):
	return mapLayer.map_to_local(map)

func mobTurnListener(emitter: Node2D)->void:
	selectedMob = emitter as Mob
	drawRange()

func has_range(attacked_mob: Mob, attacker: Mob) -> bool:
	return trace_between(selectLayer.local_to_map(attacker.position), selectLayer.local_to_map(attacked_mob.position), true).size() > 0

func walk_to_mob(attacked_mob: Mob, side: Mob.Part):
	var position_next_to = Vector2i(0,0)
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
	
	if(selectLayer.get_used_cells().find(position_next_to)>=0):
		placeMobAt(selectedMob, position_next_to)

func moveMobTo(newPlace: Vector2i):
	placeMobAt(selectedMob, newPlace)

func placeMobAt(mob: Mob, place: Vector2i):
	var astar = AStarGrid2D.new()
	astar.region = map_rect
	astar.cell_size = mapLayer.tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	
	for cell in takenSpots:
		if(cell != mapLayer.local_to_map(mob.position)):
			astar.set_point_solid(cell)
	
	mob.walking_path = trace_between(mapLayer.local_to_map(mob.global_position), place)
	move_taken_spot(mapLayer.local_to_map(mob.position), place)

func move_taken_spot(from: Vector2i, to: Vector2i):
	takenSpots.erase(from)
	takenSpots.append(to)

func trace_between(from: Vector2i, to: Vector2i, ignore_target_solid: bool = false) -> Array:
	var astar = AStarGrid2D.new()
	astar.region = map_rect
	astar.cell_size = mapLayer.tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.update()
	
	for cell in takenSpots:
		if !(cell == from or (cell == to and ignore_target_solid)):
			astar.set_point_solid(cell)
	
	return astar.get_id_path(from,to)

func initialPlaceMob(mob: Mob, place: Vector2i):
	mob.position = Vector2i(mapLayer.map_to_local(place).x, mapLayer.map_to_local(place).y + 40)
	takenSpots.append(mapLayer.local_to_map(mob.position))

func drawRange()->void:
	selectLayer.clear()
	if(selectedMob != null):
		for n in range(-selectedMob.speed,selectedMob.speed+1):
			if(int(selectedMob.position.y/96) % 2 == 0):
				for m in range(-selectedMob.speed + abs(n/2+(n%2)),selectedMob.speed - abs(n/2) + 1):
					if(mapLayer.get_cell_source_id(Vector2i(mapLayer.local_to_map(selectedMob.position).x+m, mapLayer.local_to_map(selectedMob.position).y+n))>=0):
						selectLayer.set_cell(Vector2i(mapLayer.local_to_map(selectedMob.position).x+m, mapLayer.local_to_map(selectedMob.position).y+n), 0, Vector2i(1,0))
			else:
				for m in range(-selectedMob.speed + abs(n/2),selectedMob.speed - abs(n/2+(n%2)) + 1):
					if(mapLayer.get_cell_source_id(Vector2i(mapLayer.local_to_map(selectedMob.position).x+m, mapLayer.local_to_map(selectedMob.position).y+n))>=0):
						selectLayer.set_cell(Vector2i(mapLayer.local_to_map(selectedMob.position).x+m, mapLayer.local_to_map(selectedMob.position).y+n), 0, Vector2i(1,0))
		excludeTakenSpots()
		if(!selectedMob.flying):
			cutSpotsWithoutConnectionWith(mapLayer.local_to_map(selectedMob.position))

func excludeTakenSpots():
	for spot in takenSpots:
		selectLayer.erase_cell(spot)

func cutSpotsWithoutConnectionWith(vector: Vector2i):
	var visited: Array[Vector2i] = []
	var queue: Array[Vector2i] = [vector]
	
	while queue.size() > 0:
		for cell in selectLayer.get_surrounding_cells(queue[0]):
			if(visited.find(cell,0) < 0 and selectLayer.get_cell_source_id(cell)>=0):
				queue.append(cell)
		visited.append(queue[0])
		queue.remove_at(0)
	
	for cell in selectLayer.get_used_cells():
		if(visited.find(cell,0)<0):
			selectLayer.erase_cell(cell)
