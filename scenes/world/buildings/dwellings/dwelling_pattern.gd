extends Node2D

@export var mob_type: MobAttributes

var owned: bool = false
signal entered
var hero: Hero
var just_visited = false

var available_to_recruit = 0

func enter():
	if !just_visited:
		just_visited = true
		if !owned:
			claim()
		entered.emit(self, hero, mob_type, available_to_recruit)

func enter_forced():
	if !owned:
		claim()
	entered.emit(self, hero, mob_type, available_to_recruit)

func claim():
	owned = true
	TurnSystem.connect("new_week", growth)
	growth()

func growth():
	available_to_recruit += mob_type.growth

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		hero = area as Hero
		hero.inside_something = true
		hero.connect("interact", enter)
		hero.connect("interact_forced", enter_forced)

func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		hero = area as Hero
		hero.inside_something = false
		hero.disconnect("interact", enter)
		hero.disconnect("interact_forced", enter_forced)
		hero = null
		just_visited = false
