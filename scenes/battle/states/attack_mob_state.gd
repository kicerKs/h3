extends MobState

func on_enter() -> void:
	if(get_parent().previous):
		mob.change_state(MOVING)
	else:
		pass

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	if(mob.walking_path.size() != 0):
		mob.change_state(MOVING)
	else:
		pass

func physics_update(_delta: float) -> void:
	pass
