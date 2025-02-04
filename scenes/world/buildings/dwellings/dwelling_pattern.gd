extends Node2D

@export var mob_type: MobAttributes

var owned: bool = false
signal entered
var hero: Hero
var just_visited = false

var inactive_texture
var active_texture

var available_to_recruit = 0

func _ready():
	match mob_type.mob_name:
		"Soldier":
			inactive_texture = load("res://assets/Dwellings/barracks.png")
			active_texture = load("res://assets/Dwellings/barracks_claimed.png")
		"Sniper":
			inactive_texture = load("res://assets/Dwellings/sniper_range.png")
			active_texture = load("res://assets/Dwellings/sniper_range_claimed.png")
		"Firebat":
			inactive_texture = load("res://assets/Dwellings/workshop.png")
			active_texture = load("res://assets/Dwellings/workshop_claimed.png")
		"Marine":
			inactive_texture = load("res://assets/Dwellings/academy.png")
			active_texture = load("res://assets/Dwellings/academy_claimed.png")
		"Tank":
			inactive_texture = load("res://assets/Dwellings/factory.png")
			active_texture = load("res://assets/Dwellings/factory_claimed.png")
		"Cyborg":
			inactive_texture = load("res://assets/Dwellings/assembly_line.png")
			active_texture = load("res://assets/Dwellings/assembly_line_claimed.png")
		"Angel":
			inactive_texture = load("res://assets/Dwellings/angel_portal.png")
			active_texture = load("res://assets/Dwellings/angel_portal_claimed.png")
	$Sprite2D.texture = inactive_texture

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
	$Sprite2D.texture = active_texture
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
