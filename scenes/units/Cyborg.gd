class_name Cyborg extends Mob

func _init():
	attack = 12
	defense = 7
	damage_min = 10
	damage_max = 12
	hp_base = 30
	speed = 5
	growth = 3
	ai_val = 582
	cost = 400
	scene = load("res://scenes/units/Cyborg.tscn")
	name = "Cyborg"
	mob_number = 5
	distant = true
