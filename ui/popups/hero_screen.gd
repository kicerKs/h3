extends Control

var hero: Hero

var selected_unit = -1

func show_hero_screen(h: Hero):
	self.visible = true
	hero = h
	hero.connect("army_changed", redraw_army)
	%HeroIcon.texture = hero.attributes.icon
	%HeroName.text = hero.attributes.name
	%HeroTitle.text = "Level " + str(hero.level) + " Warrior"
	%ExpBar.max_value = hero.xp_threshold
	%ExpBar.value = hero.experience
	%Attack.text = str(hero.attributes.attack)
	%Defense.text = str(hero.attributes.defense)
	match hero.morale:
		-3:
			%MoraleTexture.texture = load("res://assets/Morale minus III.png")
			%Morale.text = "-3"
		-2:
			%MoraleTexture.texture = load("res://assets/Morale minus II.png")
			%Morale.text = "-2"
		-1:
			%MoraleTexture.texture = load("res://assets/Morale minus I.png")
			%Morale.text = "-1"
		0:
			%MoraleTexture.texture = load("res://assets/Morale 0.png")
			%Morale.text = "0"
		1:
			%MoraleTexture.texture = load("res://assets/Morale I.png")
			%Morale.text = "+1"
		2:
			%MoraleTexture.texture = load("res://assets/Morale II.png")
			%Morale.text = "+2"
		3:
			%MoraleTexture.texture = load("res://assets/Morale III.png")
			%Morale.text = "+3"
	match hero.luck:
		0:
			%LuckTexture.texture = load("res://assets/Luck 0.png")
			%Luck.text = "0"
		1:
			%LuckTexture.texture = load("res://assets/Luck I.png")
			%Luck.text = "+1"
		2:
			%LuckTexture.texture = load("res://assets/Luck II.png")
			%Luck.text = "+2"
		3:
			%LuckTexture.texture = load("res://assets/Luck III.png")
			%Luck.text = "+3"
	# Skille
	var skills = hero.attributes.get_skills()
	print(hero.attributes.get_skills())
	if len(skills) > 0:
		%Skill1Icon.texture = HeroSkill.get_skill_icon(skills[0])
		%Skill1Level.text = HeroSkill.get_skill_level_name(hero.attributes.get_skill_lvl(skills[0]))
		%Skill1Name.text = HeroSkill.get_skill_name(skills[0])
		%Skill1Icon.tooltip_text = HeroSkill.get_skill_description(skills[0], hero.attributes.get_skill_lvl(skills[0]))
	else:
		%Skill1Icon.texture = HeroSkill.get_skill_icon(-1)
		%Skill1Level.text = HeroSkill.get_skill_level_name(-1)
		%Skill1Name.text = HeroSkill.get_skill_name(-1)
		%Skill1Icon.tooltip_text = "Empty skill slot. Level up your hero!"
	if len(skills) > 1:
		%Skill2Icon.texture = HeroSkill.get_skill_icon(skills[1])
		%Skill2Level.text = HeroSkill.get_skill_level_name(hero.attributes.get_skill_lvl(skills[1]))
		%Skill2Name.text = HeroSkill.get_skill_name(skills[1])
		%Skill2Icon.tooltip_text = HeroSkill.get_skill_description(skills[1], hero.attributes.get_skill_lvl(skills[1]))
	else:
		%Skill2Icon.texture = HeroSkill.get_skill_icon(-1)
		%Skill2Level.text = HeroSkill.get_skill_level_name(-1)
		%Skill2Name.text = HeroSkill.get_skill_name(-1)
		%Skill2Icon.tooltip_text = "Empty skill slot. Level up your hero!"
	if len(skills) > 2:
		%Skill3Icon.texture = HeroSkill.get_skill_icon(skills[2])
		%Skill3Level.text = HeroSkill.get_skill_level_name(hero.attributes.get_skill_lvl(skills[2]))
		%Skill3Name.text = HeroSkill.get_skill_name(skills[2])
		%Skill3Icon.tooltip_text = HeroSkill.get_skill_description(skills[2], hero.attributes.get_skill_lvl(skills[2]))
	else:
		%Skill3Icon.texture = HeroSkill.get_skill_icon(-1)
		%Skill3Level.text = HeroSkill.get_skill_level_name(-1)
		%Skill3Name.text = HeroSkill.get_skill_name(-1)
		%Skill3Icon.tooltip_text = "Empty skill slot. Level up your hero!"
	if len(skills) > 3:
		%Skill4Icon.texture = HeroSkill.get_skill_icon(skills[3])
		%Skill4Level.text = HeroSkill.get_skill_level_name(hero.attributes.get_skill_lvl(skills[3]))
		%Skill4Name.text = HeroSkill.get_skill_name(skills[3])
		%Skill4Icon.tooltip_text = HeroSkill.get_skill_description(skills[3], hero.attributes.get_skill_lvl(skills[3]))
	else:
		%Skill4Icon.texture = HeroSkill.get_skill_icon(-1)
		%Skill4Level.text = HeroSkill.get_skill_level_name(-1)
		%Skill4Name.text = HeroSkill.get_skill_name(-1)
		%Skill4Icon.tooltip_text = "Empty skill slot. Level up your hero!"
	redraw_army()

func redraw_army():
	if hero.army[0].mob != null:
		%Army1.icon = hero.army[0].mob.icon
		%Army1.text = str(hero.army[0].stack)
	else:
		%Army1.icon = Texture2D.new()
		%Army1.text = ""
	if hero.army[1].mob != null:
		%Army2.icon = hero.army[1].mob.icon
		%Army2.text = str(hero.army[1].stack)
	else:
		%Army2.icon = Texture2D.new()
		%Army2.text = ""
	if hero.army[2].mob != null:
		%Army3.icon = hero.army[2].mob.icon
		%Army3.text = str(hero.army[2].stack)
	else:
		%Army3.icon = Texture2D.new()
		%Army3.text = ""
	if hero.army[3].mob != null:
		%Army4.icon = hero.army[3].mob.icon
		%Army4.text = str(hero.army[3].stack)
	else:
		%Army4.icon = Texture2D.new()
		%Army4.text = ""
	if hero.army[4].mob != null:
		%Army5.icon = hero.army[4].mob.icon
		%Army5.text = str(hero.army[4].stack)
	else:
		%Army5.icon = Texture2D.new()
		%Army5.text = ""
	if hero.army[5].mob != null:
		%Army6.icon = hero.army[5].mob.icon
		%Army6.text = str(hero.army[5].stack)
	else:
		%Army6.icon = Texture2D.new()
		%Army6.text = ""
	if hero.army[6].mob != null:
		%Army7.icon = hero.army[6].mob.icon
		%Army7.text = str(hero.army[6].stack)
	else:
		%Army7.icon = Texture2D.new()
		%Army7.text = ""

func _on_exit_pressed() -> void:
	self.visible = false
	hero.disconnect("army_changed", redraw_army)
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_INHERIT



func _on_army_1_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 0
	else:
		hero.swap_units(selected_unit, 0)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_2_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 1
	else:
		hero.swap_units(selected_unit, 1)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_3_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 2
	else:
		hero.swap_units(selected_unit, 2)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_4_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 3
	else:
		hero.swap_units(selected_unit, 3)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_5_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 4
	else:
		hero.swap_units(selected_unit, 4)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_6_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 5
	else:
		hero.swap_units(selected_unit, 5)
		selected_unit = -1
		%Army1.release_focus()


func _on_army_7_pressed() -> void:
	if selected_unit == -1:
		selected_unit = 6
	else:
		hero.swap_units(selected_unit, 6)
		selected_unit = -1
		%Army1.release_focus()
