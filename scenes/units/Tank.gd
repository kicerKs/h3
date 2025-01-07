class_name Tank extends Mob

func _init():
	#tier 5
	attack = 12
	defense = 7
	damage_min = 10
	damage_max = 12
	hp_base = 30
	speed = 5
	growth = 3
	ai_val = 582
	cost = 400
	scene = load("res://scenes/units/Tank.tscn")
	name = "Tank"
	mob_number = 4
	distant = true
