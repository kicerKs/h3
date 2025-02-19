extends Control

var node: Node2D = null
var option = null

func _ready():
	for el in get_tree().get_nodes_in_group("LooseResources"):
		el.connect("pickedup", show_resources)
	for el in get_tree().get_nodes_in_group("LuckBuildings"):
		el.connect("pickedup", show_luck)
	for el in get_tree().get_nodes_in_group("ExpBuildings"):
		el.connect("pickedup", show_xp)
	for el in get_tree().get_nodes_in_group("MoraleBuildings"):
		el.connect("pickedup", show_morale)
	for el in get_tree().get_nodes_in_group("CityBuilding"):
		el.connect("cant_build", show_cant_build)

func show_victory():
	self.visible = true
	%Title.text = "Well done!"
	%Icon.visible = false
	%Desc.text = "You have claimed these lands, good job! Your work is done here, but maybe the Emperor will send you somewhere else..."
	option = "End"

func show_intro():
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	%Title.text = "Welcome mighty hero!"
	%Icon.visible = false
	%Desc.text = "The Galactic Empire sent you here to conquer these lands. Destroy all the foes and claim this land for the Emperor!"
	option = "None"

func show_tavern_cannot():
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	%Title.text = "Move your hero!"
	%Icon.visible = false
	%Desc.text = "You need to move your hero from the city in order to recruit a new one! Also, you need 2500 credits. And you can have only 4 heroes at the time."
	option = "None"

func show_cant_build(el: Node2D):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	node = el
	%Title.text = "Not enough resources!"
	%Icon.visible = false
	%Desc.text = "You don't have enough resources to buiild " + node.building_name + "!"
	option = "CityBuilding"

func show_resources(el: Node2D, num: int):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	node = el
	var type = node.resource_type
	%Title.text = "You picked up resources!"
	%Icon.texture = GameResources.get_resource_icon(type)
	%Desc.text = "You found a " + str(num) + " of " + GameResources.get_resource_name(type) + "!"
	option = "LooseResource"

func show_luck(el: Node2D, num: int):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	node = el
	%Title.text = "It's your lucky day!"
	%Icon.texture = load("res://assets/Luck I.png")
	%Desc.text = "Your hero gained a +" + str(num) + " to his luck!"
	option = "LuckBuildings"

func show_morale(el: Node2D, num: int):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	node = el
	if num < 0:
		%Title.text = "Bad idea!"
		%Icon.texture = load("res://assets/Morale minus I.png")
		%Desc.text = "Your hero gained a +" + str(num) + " to his troops' morale!"
	else:
		%Title.text = "Good idea!"
		%Icon.texture = load("res://assets/Morale I.png")
		%Desc.text = "Your hero gained a +" + str(num) + " to his troops' morale!"
	option = "MoraleBuildings"

func show_xp(el: Node2D):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	node = el
	%Title.text = "You learned something new!"
	%Icon.texture = load("res://assets/ph_icon.png")
	%Desc.text = "Your hero gained a 1000 experience points!"
	option = "ExpBuildings"

func _on_approve_button_pressed() -> void:
	Game.HeroManager.unpause_selected_hero()
	self.visible = false
	%Icon.visible = true
	match option:
		"LooseResource":
			node.remove()
		"LuckBuildings":
			pass #nic się nie musi zmieniać
		"ExpBuildings":
			node.finalize()
		"MoraleBuildings":
			pass #nic się nie musi zmieniać
		"CityBuilding":
			pass #nic się nie musi zmieniać
		"None":
			pass #wsm może być jeden wspólny xd
		"End":
			get_tree().quit()
