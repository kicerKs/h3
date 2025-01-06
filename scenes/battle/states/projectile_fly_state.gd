extends BattleTurnState

func on_enter() -> void:
	pass

func on_exit() -> void:
	battle.projectile.position = battle.battle_ground.map_to_local(Vector2i(-10,-10))

func update(_delta: float) -> void:
	if(battle.projectile.position != battle.target.position):
		battle.projectile.global_position = battle.projectile.global_position.move_toward(battle.target.position, 20)
	else:
		battle.fight(true)
		change_state.emit(SELECTED)

func physics_update(_delta: float) -> void:
	pass
