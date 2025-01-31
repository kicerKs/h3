extends Node

@onready var btn_hero1 = %Hero1
@onready var btn_hero2 = %Hero2
@onready var btn_hero3 = %Hero3
@onready var btn_hero4 = %Hero4

var heroes: Array[Hero]
var selected_hero: Hero

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
	print("select hero")
	%SelectedHeroIcon.texture = hero.attributes.icon
	%SelectedHeroName.text = hero.attributes.name
	%SelectedHeroAttack.text = str(hero.attributes.attack)
	%SellectedHeroDefense.text = str(hero.attributes.defense)
	# TODO: grafiki do morale i luck
	# %SelectedHeroMorale
	# %SelectedHeroLuck
	if hero.army[0].mob != null:
		%SelectedHeroUnit1.icon = hero.army[0].mob.icon
		%SelectedHeroUnit1.text = str(hero.army[0].stack)
	else:
		%SelectedHeroUnit1.icon = Texture2D.new()
		%SelectedHeroUnit1.text = " "
	if hero.army[1].mob != null:
		%SelectedHeroUnit2.icon = hero.army[1].mob.icon
		%SelectedHeroUnit2.text = str(hero.army[1].stack)
	else:
		%SelectedHeroUnit2.icon = Texture2D.new()
		%SelectedHeroUnit2.text = " "
	if hero.army[2].mob != null:
		%SelectedHeroUnit3.icon = hero.army[2].mob.icon
		%SelectedHeroUnit3.text = str(hero.army[2].stack)
	else:
		%SelectedHeroUnit3.icon = Texture2D.new()
		%SelectedHeroUnit3.text = " "
	if hero.army[3].mob != null:
		%SelectedHeroUnit4.icon = hero.army[3].mob.icon
		%SelectedHeroUnit4.text = str(hero.army[3].stack)
	else:
		%SelectedHeroUnit4.icon = Texture2D.new()
		%SelectedHeroUnit4.text = " "
	if hero.army[4].mob != null:
		%SelectedHeroUnit5.icon = hero.army[4].mob.icon
		%SelectedHeroUnit5.text = str(hero.army[4].stack)
	else:
		%SelectedHeroUnit5.icon = Texture2D.new()
		%SelectedHeroUnit5.text = " "
	if hero.army[5].mob != null:
		%SelectedHeroUnit6.icon = hero.army[5].mob.icon
		%SelectedHeroUnit6.text = str(hero.army[5].stack)
	else:
		%SelectedHeroUnit6.icon = Texture2D.new()
		%SelectedHeroUnit6.text = " "
	if hero.army[6].mob != null:
		%SelectedHeroUnit7.icon = hero.army[6].mob.icon
		%SelectedHeroUnit7.text = str(hero.army[6].stack)
	else:
		%SelectedHeroUnit7.icon = Texture2D.new()
		%SelectedHeroUnit7.text = " "

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
		#podepnij sygnały

func remove_hero(hero: Hero):
	var i = heroes.find(hero)
	match(i):
		0:
			%Hero1.icon = Texture2D.new()
			hero.disconnect("movement_changed", %Hero1MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero1MovementBar.set_bar_maximum)
			if len(heroes) >= 2:
				%Hero2.icon = Texture2D.new()
				heroes[1].disconnect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[1].disconnect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
				%Hero1.icon = heroes[1].attributes.icon
				heroes[1].connect("movement_changed", %Hero1MovementBar.set_bar_value)
				heroes[1].connect("max_movement_changed", %Hero1MovementBar.set_bar_maximum)
			if len(heroes) >= 3:
				%Hero3.icon = Texture2D.new()
				heroes[2].disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[2].disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
				%Hero2.icon = heroes[2].attributes.icon
				heroes[2].connect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[2].connect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		1:
			%Hero2.icon = Texture2D.new()
			hero.disconnect("movement_changed", %Hero2MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 3:
				%Hero3.icon = Texture2D.new()
				heroes[2].disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[2].disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
				%Hero2.icon = heroes[2].attributes.icon
				heroes[2].connect("movement_changed", %Hero2MovementBar.set_bar_value)
				heroes[2].connect("max_movement_changed", %Hero2MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		2:
			%Hero3.icon = Texture2D.new()
			hero.disconnect("movement_changed", %Hero3MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
			if len(heroes) >= 4:
				%Hero4.icon = Texture2D.new()
				heroes[3].disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
				heroes[3].disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
				%Hero3.icon = heroes[3].attributes.icon
				heroes[3].connect("movement_changed", %Hero3MovementBar.set_bar_value)
				heroes[3].connect("max_movement_changed", %Hero3MovementBar.set_bar_maximum)
		3:
			%Hero4.icon = Texture2D.new()
			hero.disconnect("movement_changed", %Hero4MovementBar.set_bar_value)
			hero.disconnect("max_movement_changed", %Hero4MovementBar.set_bar_maximum)
	print("usuwanie herosa")
	print(heroes)
	heroes.erase(hero) # musi być na końcu, bo muszę sygnały odpiąć
	print(heroes)
	print("usunieto")
