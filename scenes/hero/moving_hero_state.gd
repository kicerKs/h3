extends HeroState

var current_path_point = null

var pf
var cam

signal follow_player(pos)

func on_enter() -> void:
	pf = get_node("/root/Main/World/Pathfinding")
	cam = get_node("/root/Main/World/MainCamera")
	connect("follow_player", cam.focus)
	# Play moving animation
	current_path_point = 1
	print("Changed to moving")
	#hero.sprite.animation = "moving_d"
	hero.sprite.play("moving_d")
	pass

func on_exit() -> void:
	hero.sprite.stop()
	disconnect("follow_player", cam.focus)

func update(_delta: float) -> void:
	#Jeżeli tutaj dotarłeś, to prawdopodobnie znaczy, że trzeba zablokować poruszanie bohatera na czas walki
	#Veni Vidi Vici, Grzesiu :)
	var pos = hero.global_position
	hero.global_position = hero.global_position.move_toward(hero.current_path[current_path_point][0], 1)
	if pos.y != hero.global_position.y:
		if pos.y > hero.global_position.y:
			hero.sprite.play("moving_u")
		else:
			hero.sprite.play("moving_d")
	else:
		hero.sprite.play("moving_lr")
		if pos.x < hero.global_position.x:
			hero.sprite.flip_h = false
		else:
			hero.sprite.flip_h = true
	pf.set_green_line_to_hero(hero.global_position)
	follow_player.emit(hero.global_position)
	if(hero.position == hero.current_path[current_path_point][0]):
		hero.subtract_movement(hero.current_path[current_path_point][1])
		current_path_point += 1
		pf.pop_green_line_point()
		if (current_path_point >= len(hero.current_path)):
			hero.current_path = null
			change_state.emit(SELECTED)
