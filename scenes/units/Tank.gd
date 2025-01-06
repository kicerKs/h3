class_name Tank extends Mob

func _init():
	attack = 15
	defense = 15
	damage_min = 15
	damage_max = 20
	hp_base = 100
	speed = 7
	growth = 3
	ai_val = 750
	cost = 1000
	scene = load("res://scenes/units/Tank.tscn")
	name = "Tank"
	mob_number = 4
