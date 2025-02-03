extends BattleTurnState

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	battle.actual_plaing_mob.find_child("Sprite").play("move")
	var target_position = battle.actual_plaing_mob.walking_path.front()
	if target_position == null: #hotfix
		return
	
	if(target_position.x < battle.actual_plaing_mob.position.x):
		battle.actual_plaing_mob.find_child("Sprite").flip_h = true
	else:
		battle.actual_plaing_mob.find_child("Sprite").flip_h = false
	
	target_position.y = target_position.y + 40
	battle.actual_plaing_mob.global_position = battle.actual_plaing_mob.global_position.move_toward(target_position, 10)
	
	if Vector2i(battle.actual_plaing_mob.global_position) == target_position:
		battle.actual_plaing_mob.find_child("Sprite").stop()
		battle.actual_plaing_mob.walking_path.pop_front()
		if battle.actual_plaing_mob.walking_path.size() == 0:
			battle.actual_plaing_mob.find_child("Sprite").animation = "Idle"
			battle.actual_plaing_mob.find_child("Sprite").frame = 0
		if battle.actual_plaing_mob.walking_path.is_empty():
			if(battle.target == null):
				change_state.emit(SELECTED)
			else:
				change_state.emit(ATTACK)
