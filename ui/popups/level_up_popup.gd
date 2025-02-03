extends Control

var selected = null
var statIsDefense
var sel
var hero: Hero

func nowy(h: Hero, selection):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	selected = null
	sel = selection
	hero = h
	%Title.text = hero.name + " has gained a level!"
	%HeroIcon.texture = hero.attributes.icon
	%Level.text = hero.name + " is now at " + str(hero.level) + " level."
	statIsDefense = [true, false].pick_random()
	if !statIsDefense:
		%StatIncreaseIcon.texture = load("res://assets/attack.png")
		%StatIncreaseText.text = "Attack +1"
	else:
		%StatIncreaseIcon.texture = load("res://assets/deffence.png")
		%StatIncreaseText.text = "Defense +1"
	# Tutaj ustawianie skilli
	%Skill1.text = HeroSkill.get_skill_name_with_level(sel[0][0], sel[0][1])
	%Skill1.icon = HeroSkill.get_skill_icon(sel[0][0])
	%Skill2.text = HeroSkill.get_skill_name_with_level(sel[1][0], sel[1][1])
	%Skill2.icon = HeroSkill.get_skill_icon(sel[1][0])

func _on_skill_1_pressed() -> void:
	selected = 0

func _on_skill_2_pressed() -> void:
	selected = 1

func _on_approve_button_pressed() -> void:
	if selected != null:
		hero.finalize_levelup(statIsDefense, sel[selected][0])
	self.visible = false
	Game.HeroManager.unpause_selected_hero()
