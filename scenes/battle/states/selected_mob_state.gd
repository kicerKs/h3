extends BattleTurnState

func on_enter() -> void:
	battle.next_mob()
	battle.actual_plaing_mob.find_child("Sprite").animation = "Idle"
	battle.actual_plaing_mob.find_child("Sprite").frame = 1

func on_exit() -> void:
	battle.actual_plaing_mob.find_child("Sprite").frame = 0

func update(_delta: float) -> void:
	if battle.actual_plaing_mob.walking_path.size() > 0:
		change_state.emit(MOVING)
	pass

func physics_update(_delta: float) -> void:
	pass
