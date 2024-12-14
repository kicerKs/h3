extends Node2D
class_name Hero

@export var speed = 2

var current_path = null

func start_moving(path):
	if current_path == null:
		current_path = path
