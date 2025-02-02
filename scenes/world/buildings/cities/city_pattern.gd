extends Node2D
class_name City

@export var townhall: CityBuilding
@export var treasury: CityBuilding
@export var spaceport: CityBuilding
@export var marketplace: CityBuilding
@export var tavern: CityBuilding
@export var barracks: CityBuilding
@export var sniper_range: CityBuilding
@export var workshop: CityBuilding
@export var academy: CityBuilding
@export var factory: CityBuilding
@export var assembly_line: CityBuilding
@export var angel_portal: CityBuilding

var visiting_hero: Hero
var just_visited = false

func show_city_screen():
	if !just_visited:
		just_visited = true
		get_node("/root/Main/GUI/CityScreen").show_city_screen(self, visiting_hero)

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		visiting_hero = area as Hero
		visiting_hero.inside_something = true
		visiting_hero.connect("interact", show_city_screen)


func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		just_visited = false
		visiting_hero = area as Hero
		visiting_hero.inside_something = false
		visiting_hero.disconnect("interact", show_city_screen)
		visiting_hero = null
