extends Node2D

@export var resource_type: GameResources.ResourceTypes

var production_rate: int = 0 # amount of resources each round
var active_mine: bool = false

var inactive_texture
var active_texture

func _ready() -> void:
	add_to_group("Mines")
	TurnSystem.connect("new_day", _on_turn_system_new_day)
	print(resource_type)
	match resource_type:
		GameResources.ResourceTypes.WOOD, GameResources.ResourceTypes.METAL:
			production_rate = 2
		GameResources.ResourceTypes.CREDITS:
			production_rate = 1000
		GameResources.ResourceTypes.PSI_CRYSTAL, GameResources.ResourceTypes.COAL, GameResources.ResourceTypes.GASOLINE, GameResources.ResourceTypes.SILICON:
			production_rate = 1
	match resource_type:
		GameResources.ResourceTypes.WOOD:
			inactive_texture = load("res://assets/Kopalnie/Kopalnia drewna/kopalnia_drewna_wycieta.png")
			active_texture = load("res://assets/Kopalnie/Kopalnia drewna/kopalnia_drewna_flaga.png")
		GameResources.ResourceTypes.METAL:
			inactive_texture = load("res://assets/Kopalnie/Kopalnia metalu/kopalnia_metalu_wycieta.png")
			active_texture = load("res://assets/Kopalnie/Kopalnia metalu/kopalnia_metalu_wycieta_flaga.png")
		GameResources.ResourceTypes.COAL:
			inactive_texture = load("res://assets/Kopalnie/Kopalnia wegla/kopalnia_wegla_wycieta.png")
			active_texture = load("res://assets/Kopalnie/Kopalnia wegla/kopalnia_wegla_wycieta_flaga.png")
		GameResources.ResourceTypes.GASOLINE:
			inactive_texture = load("res://assets/Kopalnie/Rafineria/rafineria_wycieta.png")
			active_texture = load("res://assets/Kopalnie/Rafineria/rafineria_wycieta_flaga.png")
		GameResources.ResourceTypes.PSI_CRYSTAL:
			inactive_texture = load("res://assets/Kopalnie/Protoss/protoss_wyciety.png")
			active_texture = load("res://assets/Kopalnie/Protoss/protoss_wyciety_flaga.png")
		GameResources.ResourceTypes.SILICON:
			inactive_texture = load("res://assets/Kopalnie/Fabryka/fabryka_wycieta.png")
			active_texture = load("res://assets/Kopalnie/Fabryka/fabryka_wycieta_flaga.png")
		GameResources.ResourceTypes.CREDITS:
			inactive_texture = load("res://assets/Kopalnie/Centrum handlowe/centrum_handlowe_wyciete.png")
			active_texture = load("res://assets/Kopalnie/Centrum handlowe/centrum_handlowe_wyciete_flaga.png")
	$Sprite2D.texture = inactive_texture

func activate_mines() -> void:
	if not active_mine:
		active_mine = true
		$Sprite2D.texture = active_texture
		print("Mine Activated!")

func _on_turn_system_new_day() -> void:
	if active_mine:
		Game.Resources.add_resource(resource_type, production_rate)

func _on_area_entered(area) -> void:
	if area.is_in_group("Heroes"):
		var hero = area as Hero
		hero.inside_something = true
		hero.connect("interact", activate_mines)
		print(hero)

func _on_area_exited(area) -> void:
	if area.is_in_group("Heroes"):
		var hero = area as Hero
		hero.inside_something = false
		hero.disconnect("interact", activate_mines)
		print(hero)
