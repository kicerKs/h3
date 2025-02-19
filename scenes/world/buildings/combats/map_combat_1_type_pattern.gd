extends Area2D

@export var mob: MobAttributes
@export var number: int

@onready var tilemap: TileMapLayer = get_node("/root/Main/World/MapMoving")
var moving_patterns = []

var hero: Hero = null

func _ready():
	$Sprite2D.texture = mob.animations.get_frame_texture("Idle", 0)
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
	print(tilemap.get_cell_source_id(my_cell+Vector2i(-1,-1)))
	tilemap.set_cell(my_cell+Vector2i(-1,0), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(-1,1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,-1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell, 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(0,1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,-1), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,0), 4, Vector2i(0,0))
	tilemap.set_cell(my_cell+Vector2i(1,1), 4, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()
	get_parent().get_parent().add_battle()

func start_combat():
	get_node("/root/Main/BattleManager").connect("battle_conquered", remove_self)
	get_node("/root/Main/BattleManager").initialize_battle(hero, divide_units())

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
	get_parent().get_parent().remove_battle()
	queue_free()

func divide_units():
	var units: Array[ArmyUnit] = []
	var possibilities = [1, 2, 3, 4, 5, 6, 7]
	var result = possibilities.pick_random()
	while result > number:
		result = possibilities.pick_random()
	print(result)
	match result:
		1:
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, number))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
		2:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, number-one))
			units.append(ArmyUnit.nowy(null, -1))
		3:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, number - (2 * one)))
			units.append(ArmyUnit.nowy(null, -1))
		4:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, number - (3 * one)))
		5:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, number - (4 * one)))
		6:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(null, -1))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, number - (5 * one)))
		7:
			var one = int(number/result)
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, one))
			units.append(ArmyUnit.nowy(mob, number - (6 * one)))
	print(units)
	return units

func calculate_xp():
	return mob.hp_base * number

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
