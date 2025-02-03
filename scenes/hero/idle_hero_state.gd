extends HeroState

func on_enter():
	var my_cell = hero.tilemap.local_to_map(hero.global_position)
	hero.previous_cell_id = hero.tilemap.get_cell_source_id(my_cell)
	hero.tilemap.set_cell(my_cell, 0, Vector2i(0,0))

func on_exit():
	var my_cell = hero.tilemap.local_to_map(hero.global_position)
	hero.tilemap.set_cell(my_cell, hero.previous_cell_id, Vector2i(0,0))
