class_name Sniper extends Mob

func _init():
	attack = 6
	defence = 3
	damage_min = 2
	damage_max = 3
	hp_base = 10
	speed = 4
	growth = 9
	ai_val = 184
	cost = 100
	scene = load("res://scenes/units/Sniper.tscn")
	name = "Sniper"
