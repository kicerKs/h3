extends Node2D

signal pickedup
var hero: Hero

func pickup():
	if hero.luck_bonus == -1:
		var amount = [1, 2, 3].pick_random()
		hero.luck_bonus = amount
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
