class_name Marine extends Mob

func _init():
	attack = 10
	defence = 12
	damage_min = 6
	damage_max = 9
	hp_base = 35
	speed = 5
	growth = 4
	ai_val = 445
	cost = 300
	scene = load("res://scenes/units/Marine.tscn")
	name = "Marine"
