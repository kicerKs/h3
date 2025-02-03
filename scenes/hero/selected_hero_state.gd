extends HeroState

func on_enter() -> void:
	# Update GUI (indicate selected hero, its units etc.)
	# Play animation
	print("Changed to selected")
	var my_cell = hero.tilemap.local_to_map(hero.global_position)
	hero.previous_cell_id = hero.tilemap.get_cell_source_id(my_cell)
	hero.tilemap.set_cell(my_cell, 0, Vector2i(0,0))
	pass

func on_exit():
	var my_cell = hero.tilemap.local_to_map(hero.global_position)
	hero.tilemap.set_cell(my_cell, hero.previous_cell_id, Vector2i(0,0))

func update(_delta: float) -> void:
	# Check for interaction with something on the map
	if hero.inside_something:
		hero.interact.emit()
	pass

func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_click_left") and event.is_pressed() and not event.is_echo():
		var pf = get_node("/root/Main/World/Pathfinding")
		var path = pf.start_pathfinding(hero, hero.get_movement())
		if path != null:
			hero.current_path = path
			change_state.emit(MOVING)
