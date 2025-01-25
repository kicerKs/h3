extends HeroState

var current_path_point = null

func on_enter() -> void:
	# Play moving animation
	current_path_point = 1
	print("Changed to moving")
	pass

func update(_delta: float) -> void:
	#Jeżeli tutaj dotarłeś, to prawdopodobnie znaczy, że trzeba zablokować poruszanie bohatera na czas walki
	#Veni Vidi Vici, Grzesiu :)
	hero.global_position = hero.global_position.move_toward(hero.current_path[current_path_point], 1)
	if(hero.position == hero.current_path[current_path_point]):
		current_path_point += 1
		if (current_path_point >= len(hero.current_path)):
			hero.current_path = null
			change_state.emit(SELECTED)
