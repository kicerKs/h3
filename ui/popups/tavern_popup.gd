extends Control

var selection
var chosen = -1
var end_position = null

func show_tavern_popup(pos: Vector2):
	self.visible = true
	selection = Game.HeroManager.get_random_hero_selection()
	end_position = pos
	%Hero1.icon = selection[0].attributes.icon
	%Hero2.icon = selection[1].attributes.icon
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().find_child("CityScreen").process_mode = Node.PROCESS_MODE_DISABLED

func _on_hero_1_pressed() -> void:
	chosen = 0
	%HeroDesc.text = selection[0].attributes.name + " is a level " + str(selection[0].level) + " Warrior."

func _on_hero_2_pressed() -> void:
	chosen = 1
	%HeroDesc.text = selection[1].attributes.name + " is a level " + str(selection[1].level) + " Warrior."

func _on_cancel_button_pressed() -> void:
	self.visible = false
	chosen = -1
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_INHERIT
	get_parent().find_child("CityScreen").process_mode = Node.PROCESS_MODE_INHERIT

func _on_approve_button_pressed() -> void:
	self.visible = false
	Game.HeroManager.recruit_hero(selection[chosen], end_position)
	chosen = -1
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_INHERIT
	get_parent().find_child("CityScreen").process_mode = Node.PROCESS_MODE_INHERIT
