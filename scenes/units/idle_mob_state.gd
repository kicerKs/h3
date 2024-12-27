extends MobState

func on_enter() -> void:
	mob.find_child("Sprite").animation = "Idle"
	mob.find_child("Sprite").frame = 0
	mob.mob_ended.emit()

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
