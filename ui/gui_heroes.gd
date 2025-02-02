extends Node

@onready var btn_hero1 = %Hero1
@onready var btn_hero2 = %Hero2
@onready var btn_hero3 = %Hero3
@onready var btn_hero4 = %Hero4

var heroes: Array[Hero]
var selected_hero: Hero

var selected_unit = -1

func _on_button_new_turn_pressed() -> void:
	TurnSystem.new_turn()

func _on_turn_system_update_turn(day: Variant, week: Variant, month: Variant) -> void:
	%MonthLabel.text = "Month: " + str(month)
	%WeekLabel.text = "Week: " + str(week)
	%DayLabel.text = "Day: " + str(day)

func _on_hero_1_pressed() -> void:
	if len(heroes) >= 1:
		select_hero(heroes[0])

func _on_hero_2_pressed() -> void:
	if len(heroes) >= 2:
		select_hero(heroes[1])

func _on_hero_3_pressed() -> void:
	if len(heroes) >= 3:
		select_hero(heroes[2])

func _on_hero_4_pressed() -> void:
	if len(heroes) >= 4:
		select_hero(heroes[3])

func select_hero(hero: Hero):
	if selected_hero != null:
		selected_hero.disconnect("army_changed", redraw_army)
	selected_hero = hero
	selected_hero.connect("army_changed", redraw_army)
	%SelectedHeroIcon.texture = hero.attributes.icon
	%SelectedHeroName.text = hero.attributes.name
	%SelectedHeroAttack.text = str(hero.attributes.attack)
	%SellectedHeroDefense.text = str(hero.attributes.defense)
	# TODO: grafiki do morale i luck
	match selected_hero.morale:
		-3:
			%SelectedHeroMorale.texture = load("res://assets/Morale minus III.png")
		-2:
			%SelectedHeroMorale.texture = load("res://assets/Morale minus II.png")
		-1:
			%SelectedHeroMorale.texture = load("res://assets/Morale minus I.png")
		0:
			%SelectedHeroMorale.texture = load("res://assets/Morale 0.png")
		1:
			%SelectedHeroMorale.texture = load("res://assets/Morale I.png")
		2:
			%SelectedHeroMorale.texture = load("res://assets/Morale II.png")
		3:
			%SelectedHeroMorale.texture = load("res://assets/Morale III.png")
	match selected_hero.luck:
		0:
			%SelectedHeroLuck.texture = load("res://assets/Luck 0.png")
		1:
			%SelectedHeroLuck.texture = load("res://assets/Luck I.png")
		2:
			%SelectedHeroLuck.texture = load("res://assets/Luck II.png")
		3:
			%SelectedHeroLuck.texture = load("res://assets/Luck III.png")
	redraw_army()

func add_hero(hero: Hero):
	if len(heroes) < 4:
		match len(heroes):
			0:
				%Hero1.icon = hero.attributes.icon
				hero.connect("movement_changed", %Hero1MovementBar.set_bar_value)
				hero.connect("max_movement_changed", %Hero1MovementBar.set_bar_maximum)
			1:
				%Hero2.icon = hero.attributes.icon
				hero.connect("movement_changed", %Hero2MovementBar.set_bar_value)
				hero.connect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			2:
				%Hero3.icon = hero.attributes.icon
				hero.connect("movement_changed", %Hero3MovementBar.set_bar_value)
				hero.connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
			3:
				%Hero4.icon = hero.attributes.icon
				hero.connect("movement_changed", %Hero4MovementBar.set_bar_value)
				hero.connect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
		heroes.append(hero)
		select_hero(hero)
		#podepnij sygnały

func remove_hero(hero: Hero):
	var i = heroes.find(hero)
	match(i):
		0:
			%Hero1.icon = Texture2D.new()
			%Hero1MovementBar.value = 0
			hero.disconnect("movement_changed", %Hero1MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero1MovementBar.set_bar_maximum)
			if len(heroes) >= 2:
				%Hero2.icon = Texture2D.new()
				%Hero1MovementBar.max_value = %Hero2MovementBar.max_value
				%Hero1MovementBar.value = %Hero2MovementBar.value
				%Hero2MovementBar.value = 0
				heroes[1].disconnect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[1].disconnect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
				%Hero1.icon = heroes[1].attributes.icon
				heroes[1].connect("movement_changed", %Hero1MovementBar.set_bar_value)
				heroes[1].connect("max_movement_changed", %Hero1MovementBar.set_bar_maximum)
			if len(heroes) >= 3:
				%Hero3.icon = Texture2D.new()
				%Hero2MovementBar.max_value = %Hero3MovementBar.max_value
				%Hero2MovementBar.value = %Hero3MovementBar.value
				%Hero3MovementBar.value = 0
				heroes[2].disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[2].disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
				%Hero2.icon = heroes[2].attributes.icon
				heroes[2].connect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[2].connect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				%Hero3MovementBar.max_value = %Hero4MovementBar.max_value
				%Hero3MovementBar.value = %Hero4MovementBar.value
				%Hero4MovementBar.value = 0
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		1:
			%Hero2.icon = Texture2D.new()
			%Hero2MovementBar.value = 0
			hero.disconnect("movement_changed", %Hero2MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 3:
				%Hero3.icon = Texture2D.new()
				%Hero2MovementBar.max_value = %Hero3MovementBar.max_value
				%Hero2MovementBar.value = %Hero3MovementBar.value
				%Hero3MovementBar.value = 0
				heroes[2].disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[2].disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
				%Hero2.icon = heroes[2].attributes.icon
				heroes[2].connect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[2].connect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				%Hero3MovementBar.max_value = %Hero4MovementBar.max_value
				%Hero3MovementBar.value = %Hero4MovementBar.value
				%Hero4MovementBar.value = 0
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		2:
			%Hero3.icon = Texture2D.new()
			%Hero3MovementBar.value = 0
			hero.disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				%Hero3MovementBar.max_value = %Hero4MovementBar.max_value
				%Hero3MovementBar.value = %Hero4MovementBar.value
				%Hero4MovementBar.value = 0
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		3:
			%Hero4.icon = Texture2D.new()
			%Hero4MovementBar.value = 0
			hero.disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
	heroes.erase(hero) # musi być na końcu, bo muszę sygnały odpiąć
	clear_selected()

func redraw_army():
	if selected_hero.army[0].mob != null:
		%SelectedHeroUnit1.icon = selected_hero.army[0].mob.icon
		%SelectedHeroUnit1.text = str(selected_hero.army[0].stack)
	else:
		%SelectedHeroUnit1.icon = Texture2D.new()
		%SelectedHeroUnit1.text = " "
	if selected_hero.army[1].mob != null:
		%SelectedHeroUnit2.icon = selected_hero.army[1].mob.icon
		%SelectedHeroUnit2.text = str(selected_hero.army[1].stack)
	else:
		%SelectedHeroUnit2.icon = Texture2D.new()
		%SelectedHeroUnit2.text = " "
	if selected_hero.army[2].mob != null:
		%SelectedHeroUnit3.icon = selected_hero.army[2].mob.icon
		%SelectedHeroUnit3.text = str(selected_hero.army[2].stack)
	else:
		%SelectedHeroUnit3.icon = Texture2D.new()
		%SelectedHeroUnit3.text = " "
	if selected_hero.army[3].mob != null:
		%SelectedHeroUnit4.icon = selected_hero.army[3].mob.icon
		%SelectedHeroUnit4.text = str(selected_hero.army[3].stack)
	else:
		%SelectedHeroUnit4.icon = Texture2D.new()
		%SelectedHeroUnit4.text = " "
	if selected_hero.army[4].mob != null:
		%SelectedHeroUnit5.icon = selected_hero.army[4].mob.icon
		%SelectedHeroUnit5.text = str(selected_hero.army[4].stack)
	else:
		%SelectedHeroUnit5.icon = Texture2D.new()
		%SelectedHeroUnit5.text = " "
	if selected_hero.army[5].mob != null:
		%SelectedHeroUnit6.icon = selected_hero.army[5].mob.icon
		%SelectedHeroUnit6.text = str(selected_hero.army[5].stack)
	else:
		%SelectedHeroUnit6.icon = Texture2D.new()
		%SelectedHeroUnit6.text = " "
	if selected_hero.army[6].mob != null:
		%SelectedHeroUnit7.icon = selected_hero.army[6].mob.icon
		%SelectedHeroUnit7.text = str(selected_hero.army[6].stack)
	else:
		%SelectedHeroUnit7.icon = Texture2D.new()
		%SelectedHeroUnit7.text = " "

func clear_selected():
	%SelectedHeroIcon.texture = load("res://assets/helmet.png")
	%SelectedHeroName.text = ""
	%SelectedHeroAttack.text = ""
	%SellectedHeroDefense.text = ""
	%SelectedHeroMorale.texture = load("res://assets/Morale 0.png")
	%SelectedHeroLuck.texture = load("res://assets/Luck 0.png")
	
	%SelectedHeroUnit1.icon = Texture2D.new()
	%SelectedHeroUnit1.text = " "
	%SelectedHeroUnit2.icon = Texture2D.new()
	%SelectedHeroUnit2.text = " "
	%SelectedHeroUnit3.icon = Texture2D.new()
	%SelectedHeroUnit3.text = " "
	%SelectedHeroUnit4.icon = Texture2D.new()
	%SelectedHeroUnit4.text = " "
	%SelectedHeroUnit5.icon = Texture2D.new()
	%SelectedHeroUnit5.text = " "
	%SelectedHeroUnit6.icon = Texture2D.new()
	%SelectedHeroUnit6.text = " "
	%SelectedHeroUnit7.icon = Texture2D.new()
	%SelectedHeroUnit7.text = " "
	selected_unit = -1
	selected_hero = null

func _on_selected_hero_unit_1_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 0
		else:
			selected_hero.swap_units(selected_unit, 0)
			selected_unit = -1
			%SelectedHeroUnit1.release_focus()


func _on_selected_hero_unit_2_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 1
		else:
			selected_hero.swap_units(selected_unit, 1)
			selected_unit = -1
			%SelectedHeroUnit2.release_focus()


func _on_selected_hero_unit_3_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 2
		else:
			selected_hero.swap_units(selected_unit, 2)
			selected_unit = -1
			%SelectedHeroUnit3.release_focus()


func _on_selected_hero_unit_4_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 3
		else:
			selected_hero.swap_units(selected_unit, 3)
			selected_unit = -1
			%SelectedHeroUnit4.release_focus()


func _on_selected_hero_unit_5_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 4
		else:
			selected_hero.swap_units(selected_unit, 4)
			selected_unit = -1
			%SelectedHeroUnit5.release_focus()


func _on_selected_hero_unit_6_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 5
		else:
			selected_hero.swap_units(selected_unit, 5)
			selected_unit = -1
			%SelectedHeroUnit6.release_focus()


func _on_selected_hero_unit_7_pressed() -> void:
	if selected_hero != null:
		if selected_unit == -1:
			selected_unit = 6
		else:
			selected_hero.swap_units(selected_unit, 6)
			selected_unit = -1
			%SelectedHeroUnit7.release_focus()


func _on_button_use_hero_pressed() -> void:
	selected_hero.interact_forced.emit()


func _on_button_show_hero_pressed() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().find_child("HeroScreen").show_hero_screen(selected_hero)


func _on_button_city_pressed() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().find_child("CityScreen").show_city_screen(get_node("/root/Main/World/Cities/City"), get_node("/root/Main/World/Cities/City").visiting_hero)
