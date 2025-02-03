extends Node2D

@export var resource_type: GameResources.ResourceTypes

@onready var tilemap: TileMapLayer = get_node("/root/Main/World/MapMoving")
var previous_cell

signal pickedup
var picked = false

func _ready():
	var my_cell = tilemap.local_to_map(position)
	previous_cell = tilemap.get_cell_source_id(my_cell)
	tilemap.set_cell(my_cell, 5, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()
	$Sprite2D.texture = GameResources.get_resource_icon(resource_type)

func pickup():
	if !picked:
		var amount
		if resource_type == GameResources.ResourceTypes.CREDITS:
			amount = [500, 600, 700, 800, 900, 1000].pick_random()
		elif resource_type == GameResources.ResourceTypes.WOOD or resource_type == GameResources.ResourceTypes.METAL:
			amount = [5, 6, 7, 8, 9, 1].pick_random()
		else:
			amount = [3, 4, 5, 6].pick_random()
		pickedup.emit(self, amount)
		picked = true

func remove():
	remove_from_group("LooseResources")
	var my_cell = tilemap.local_to_map(position)
	tilemap.set_cell(my_cell, previous_cell, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()
	queue_free()

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		var hero = area as Hero
		hero.inside_something = true
		hero.connect("interact", pickup)

func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		var hero = area as Hero
		hero.inside_something = false
		hero.disconnect("interact", pickup)
