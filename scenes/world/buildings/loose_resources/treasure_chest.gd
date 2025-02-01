extends Node2D

@onready var tilemap: TileMapLayer = get_node("/root/Main/World/MapMoving")
var previous_cell

signal pickedup
var picked = false
var selection
var hero: Hero

func _ready():
	var my_cell = tilemap.local_to_map(position)
	previous_cell = tilemap.get_cell_source_id(my_cell)
	tilemap.set_cell(my_cell, 5, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()

func pickup():
	if !picked:
		print("lol")
		selection = [[1000, 500], [1500, 1000], [2000, 1500]].pick_random()
		picked = true
		pickedup.emit(self, selection)

func chosen(what):
	if what == 0:
		Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, selection[0])
	else:
		hero.add_xp(selection[1])
	remove_from_group("TreasureChests")
	var my_cell = tilemap.local_to_map(position)
	tilemap.set_cell(my_cell, previous_cell, Vector2i(0,0))
	get_node("/root/Main/World/Pathfinding").update()
	queue_free()

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		hero = area as Hero
		hero.inside_something = true
		hero.connect("interact", pickup)

func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		hero = area as Hero
		hero.inside_something = false
		hero.disconnect("interact", pickup)
		hero = null
