extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var hero = Hero.new()
	hero.army = {
		Angel.new(): 1,
		Soldier.new(): 12,
		Firebat.new(): 3,
		Tank.new(): 8,
	}
	var oponent = {
		Cyborg.new(): 1,
		Sniper.new(): 1,
		Firebat.new(): 1,
		Marine.new(): 1,
	}
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
