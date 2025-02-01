extends Node2D

var hero: Hero
var visited_heroes = []

signal pickedup

func pickup():
	if hero.attributes.name not in visited_heroes:
		visited_heroes.append(hero.attributes.name)
		pickedup.emit(self)

func finalize():
	hero.add_xp(1000)

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
