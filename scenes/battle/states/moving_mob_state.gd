extends BattleTurnState

func on_enter() -> void:
	pass

func update(_delta: float) -> void:
	var target_position = battle.actual_plaing_mob.walking_path.front()
	target_position.y = target_position.y + 40
	battle.actual_plaing_mob.global_position = battle.actual_plaing_mob.global_position.move_toward(target_position, 20)
	
	if Vector2i(battle.actual_plaing_mob.global_position) == target_position:
		battle.actual_plaing_mob.walking_path.pop_front()
		if battle.actual_plaing_mob.walking_path.is_empty():
			if(get_parent().prevous_state_name == SELECTED):
				change_state.emit(SELECTED)
			elif(get_parent().prevous_state_name == ATTACK):
				change_state.emit(ATTACK)
