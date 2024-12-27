extends MobState

var current_path_point = null

func on_enter() -> void:
	# Play moving animation
	print("tapatapa")
	pass

func update(_delta: float) -> void:
	var target_position = mob.walking_path.front()
	target_position.y = target_position.y + 40
	mob.global_position = mob.global_position.move_toward(target_position, 20)
	
	if Vector2i(mob.global_position) == target_position:
		mob.walking_path.pop_front()
		if mob.walking_path.is_empty():
			if(get_parent().prevous_state_name == SELECTED):
				change_state.emit(IDLE)
			elif(get_parent().prevous_state_name == ATTACK):
				change_state.emit(ATTACK)
				print("AAATAAACK")
