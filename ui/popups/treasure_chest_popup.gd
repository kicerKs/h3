extends Control

var node: Node2D

var selected = null
var sel

func _ready():
	for el in get_tree().get_nodes_in_group("TreasureChests"):
		el.connect("pickedup", nowy)

func nowy(n: Node2D, selection):
	Game.HeroManager.pause_selected_hero()
	self.visible = true
	selected = null
	sel = selection
	node = n
	%Title.text = "You picked up a treasure chest!"
	%Desc.text = "Choose wisely..."
	%CreditsButton.text = str(selection[0])
	%ExperienceButton.text = str(selection[1])

func _on_approve_button_pressed() -> void:
	if selected != null:
		node.chosen(selected)
	self.visible = false
	Game.HeroManager.unpause_selected_hero()

func _on_credits_button_pressed() -> void:
	selected = 0

func _on_experience_button_pressed() -> void:
	selected = 1
