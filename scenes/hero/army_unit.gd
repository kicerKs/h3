class_name ArmyUnit extends Resource

@export var mob: MobAttributes
@export var stack: int

func _init(mob: MobAttributes, stack: int):
	self.mob = mob
	self.stack = stack
