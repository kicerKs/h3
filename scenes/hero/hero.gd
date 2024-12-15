extends Node2D
class_name Hero

@export var speed = 2
var attack = 0
var defense = 0
var luck = 0 
var army: Dictionary

var current_path = null

func start_moving(path):
	if current_path == null:
		current_path = path
