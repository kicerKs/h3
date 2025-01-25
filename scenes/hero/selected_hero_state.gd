extends HeroState

func on_enter() -> void:
	# Update GUI (indicate selected hero, its units etc.)
	# Play animation
	print("Changed to selected")
	pass

func update(_delta: float) -> void:
	# Check if there is a path, if it is change state
	#if hero.current_path != null:
	#	change_state.emit(MOVING)
	pass

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_click_left"):
		var pf = get_node("/root/Main/World/Pathfinding")
		var path = pf.start_pathfinding()
		if path != null:
			hero.current_path = path
			change_state.emit(MOVING)
