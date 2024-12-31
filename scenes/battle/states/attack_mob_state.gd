extends BattleTurnState

func on_enter() -> void:
	if(battle.actual_plaing_mob.walking_path.size() != 0):
		change_state.emit(MOVING)
	else:
		battle.fight()
		change_state.emit(SELECTED)

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
