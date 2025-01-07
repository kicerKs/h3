class_name Angel extends Mob

func _init():
	#tier 5
	attack = 20
	defense = 20
	damage_min = 50
	damage_max = 50
	hp_base = 200
	speed = 12
	growth = 1
	ai_val = 5019
	cost = 3000
	scene = load("res://scenes/units/Angel.tscn")
	name = "Angel"
	mob_number = 6
	distant = false
