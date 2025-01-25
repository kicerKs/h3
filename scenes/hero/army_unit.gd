class_name ArmyUnit extends Node

var mob: Mob
var stack: int

func _init(mob: Mob, stack: int):
	self.mob = mob
	self.stack = stack
