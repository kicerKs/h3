extends HeroState

var current_path_point = null

var pf

func on_enter() -> void:
	pf = get_node("/root/Main/World/Pathfinding")
	# Play moving animation
	current_path_point = 1
	print("Changed to moving")
	pass

func update(_delta: float) -> void:
	#Jeżeli tutaj dotarłeś, to prawdopodobnie znaczy, że trzeba zablokować poruszanie bohatera na czas walki
	#Veni Vidi Vici, Grzesiu :)
	hero.global_position = hero.global_position.move_toward(hero.current_path[current_path_point][0], 1)
	pf.set_green_line_to_hero(hero.global_position)
	if(hero.position == hero.current_path[current_path_point][0]):
		hero.subtract_movement(hero.current_path[current_path_point][1])
		current_path_point += 1
		pf.pop_green_line_point()
		if (current_path_point >= len(hero.current_path)):
			hero.current_path = null
			change_state.emit(SELECTED)
