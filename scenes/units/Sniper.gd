class_name Sniper extends Mob

func _init():
	attack = 6
	defense = 3
	damage_min = 2
	damage_max = 3
	hp_base = 10
	speed = 4
	growth = 9
	ai_val = 126
	cost = 100
	scene = load("res://scenes/units/Sniper.tscn")
	mob_name = "Sniper"
	mob_number = 1
	distant = true
