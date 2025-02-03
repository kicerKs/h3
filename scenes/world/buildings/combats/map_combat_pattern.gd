extends Area2D

@export var units: Array[ArmyUnit]
var hero: Hero = null

@onready var tilemap: TileMapLayer = get_node("/root/Main/World/MapMoving")
var moving_patterns = []

func _ready():
	$Sprite2D.texture = units[0].mob.animations.get_frame_texture("Idle", 0)
	# Zapisz jakie były wcześniej movepatterny
	var my_cell = tilemap.local_to_map(position)
	moving_patterns.append([
		tilemap.get_cell_source_id(my_cell+Vector2i(-1,-1)),
		tilemap.get_cell_source_id(my_cell+Vector2i(-1,0)),
		tilemap.get_cell_source_id(my_cell+Vector2i(-1,1))
	])
	moving_patterns.append([
		tilemap.get_cell_source_id(my_cell+Vector2i(0,-1)),
		tilemap.get_cell_source_id(my_cell),
		tilemap.get_cell_source_id(my_cell+Vector2i(0,1))
	])
	moving_patterns.append([
		tilemap.get_cell_source_id(my_cell+Vector2i(1,-1)),
		tilemap.get_cell_source_id(my_cell+Vector2i(1,0)),
		tilemap.get_cell_source_id(my_cell+Vector2i(1,1))
	])
	#nadpisz na enemies
	tilemap.set_cell(my_cell+Vector2i(-1,-1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(-1,0), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(-1,1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,-1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell, 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,-1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,0), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,1), 4, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()

func start_combat():
	get_node("/root/Main/BattleManager").connect("battle_conquered", remove_self)
	while len(units) < 7:
		units.append(ArmyUnit.nowy(null, -1))
	get_node("/root/Main/BattleManager").initialize_battle(hero, units)

func remove_self():
	hero.add_xp(calculate_xp())
	get_node("/root/Main/BattleManager").disconnect("battle_conquered", remove_self)
	get_parent().get_parent().remove_combat(self.position)
	var my_cell = tilemap.local_to_map(position)
	tilemap.set_cell(my_cell+Vector2i(-1,-1), moving_patterns[0][0], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(-1,0), moving_patterns[0][1], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(-1,1), moving_patterns[0][2], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,-1), moving_patterns[1][0], Vector2i(0,0))
	tilemap.set_cell(my_cell, moving_patterns[1][1], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,1), moving_patterns[1][2], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,-1), moving_patterns[2][0], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,0), moving_patterns[2][1], Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,1), moving_patterns[2][2], Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()
	queue_free()

func calculate_xp():
	var xp = 0
	for au in units:
		xp += au.mob.hp_base * au.stack
	return xp

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		hero = area as Hero
		hero.inside_something = true
		hero.connect("interact", start_combat)
		print(hero)


func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		var hero = area as Hero
		hero.inside_something = false
		hero.disconnect("interact", start_combat)
		print(hero)
