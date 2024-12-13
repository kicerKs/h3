extends HeroState

func on_enter() -> void:
	# Update GUI (indicate selected hero, its units etc.)
	# Play animation
	print("Changed to selected")
	pass

func update(_delta: float) -> void:
	# Check if there is a path, if it is change state
	if hero.current_path != null:
		change_state.emit(MOVING)
	pass
