class_name Firebat extends Mob

func _init():
	attack = 8
	defence = 8
	damage_min = 3
	damage_max = 6
	hp_base = 25
	speed = 6
	growth = 7
	ai_val = 351
	cost = 200
	scene = load("res://scenes/units/Firebat.tscn")
	flying = true
