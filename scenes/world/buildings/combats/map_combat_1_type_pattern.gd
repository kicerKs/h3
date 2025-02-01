extends Area2D

@export var mob: MobAttributes
@export var number: int

var hero: Hero = null

func _ready():
	$Sprite2D.texture = mob.animations.get_frame_texture("Idle", 0)

func start_combat():
	var obstacles = {
		Vector2i(6,6): 1,
		Vector2i(5,6): 1,
		Vector2i(4,6): 1,
		Vector2i(7,6): 1,
		Vector2i(6,5): 1,
		Vector2i(7,5): 1,
		Vector2i(7,4): 1,
		Vector2i(8,4): 1,
		Vector2i(8,3): 1,
		Vector2i(9,3): 1,
		Vector2i(6,7): 1,
	}
	print(divide_units())
	get_node("/root/Main/BattleManager").initialize_battle(hero, divide_units(), obstacles)

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
