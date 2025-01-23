class_name Cyborg extends Mob

func _init():
	#tier 6
	attack = 15
	defense = 15
	damage_min = 15
	damage_max = 25
	hp_base = 100
	speed = 7
	growth = 2
	ai_val = 1946
	cost = 1000
	scene = load("res://scenes/units/Cyborg.tscn")
	mob_name = "Cyborg"
	mob_number = 5
	distant = false
