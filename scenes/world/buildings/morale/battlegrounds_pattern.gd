extends Node2D

signal pickedup
var hero: Hero

func pickup():
	if hero.morale_bonus == -99:
		var amount = [-3, -2, -1, 1, 2, 3].pick_random()
		hero.morale_bonus = amount
		pickedup.emit(self, amount)

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
