extends MobState

signal mob_selected(Mob)

func on_enter() -> void:
	mob.find_child("Sprite").animation = "Idle"
	mob.find_child("Sprite").frame = 1
	mob_selected.emit(owner)
	

func on_exit() -> void:
	mob.find_child("Sprite").frame = 0

func update(_delta: float) -> void:
	if mob.walking_path.size() > 0:
		change_state.emit(MOVING)
	pass

func physics_update(_delta: float) -> void:
	pass
