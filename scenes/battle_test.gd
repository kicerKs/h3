extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var hero: Hero = get_node("/root/Main/World/Heroes/Player")
	print(hero.attributes.attack)
	print(hero)
	
	var oponent: Array[ArmyUnit] = [
		ArmyUnit.nowy(load("res://scenes/units/presets/cyborg.tres"), 1),
		ArmyUnit.nowy(load("res://scenes/units/presets/sniper.tres"), 1),
		ArmyUnit.nowy(load("res://scenes/units/presets/firebat.tres"), 1),
		ArmyUnit.nowy(load("res://scenes/units/presets/marine.tres"), 1)
	]
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
	find_parent("Main").find_child("BattleManager", true, false).initialize_battle(hero, oponent, obstacles)
