class_name ArmyUnit extends Resource

@export var mob: MobAttributes
@export var stack: int

#func _init(mob: MobAttributes, stack: int):
#	self.mob = mob
#	self.stack = stack

static func nowy(mob: MobAttributes, stack: int):
	var unit = ArmyUnit.new()
	unit.mob = mob
	unit.stack = stack
	return unit
