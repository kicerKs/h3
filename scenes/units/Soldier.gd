class_name Soldier extends Mob

func _init():
	attack = 4
	defense = 5
	damage_min = 1
	damage_max = 3
	hp_base = 10
	speed = 4
	growth = 14
	ai_val = 80
	cost = 60
	scene = load("res://scenes/units/Soldier.tscn")
	mob_name = "Soldier"
	mob_number = 0
