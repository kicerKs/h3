extends Control

var node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for el in get_tree().get_nodes_in_group("CityBuilding"):
		el.connect("try_to_build", show_building_screen)

func show_building_screen(n: Node2D):
	self.visible = true
	node = n
	%Title.text = "Building"
	%Desc.text = "Do you want to build the " + node.building_name + "?"

func _on_approve_button_pressed() -> void:
	self.visible = false
	node.build()
	node = null

func _on_cancel_button_pressed() -> void:
	self.visible = false
	node = null
