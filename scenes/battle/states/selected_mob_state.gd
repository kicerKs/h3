extends BattleTurnState

func on_enter() -> void:
	battle.block_actions = false
	flip_mob()
	battle.next_mob()
	battle.actual_plaing_mob.find_child("Sprite").stop()
	battle.actual_plaing_mob.find_child("Sprite").animation = "Idle"
	battle.actual_plaing_mob.find_child("Sprite").frame = 1

func on_exit() -> void:
	battle.block_actions = true
	battle.actual_plaing_mob.find_child("Sprite").frame = 0

func update(_delta: float) -> void:
	if battle.actual_plaing_mob.walking_path.size() > 0:
		if(battle.target == null):
			change_state.emit(MOVING)
		else:
			change_state.emit(ATTACK)
	pass

func physics_update(_delta: float) -> void:
	pass

func flip_mob():
	if(battle.actual_plaing_mob!= null):
		if(battle.actual_plaing_mob.player):
			battle.actual_plaing_mob.find_child("Sprite").flip_h = false
		else:
			battle.actual_plaing_mob.find_child("Sprite").flip_h = true
