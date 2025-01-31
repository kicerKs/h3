extends Node
class_name HeroManager

@onready var available_heroes: Array[Hero] = [
	$Calamity,
	$Falcon,
	$General,
	$Grimemaw,
	$Minas,
	$Prime,
	$Zephyr
]
var active_heroes: Array[Hero]

func _ready():
	pass

func recruit_hero(hero: Hero, pos: Vector2):
	if hero in available_heroes and len(active_heroes) < 4:
		available_heroes.erase(hero)
		active_heroes.append(hero)
		get_node("/root/Main/GUI").add_hero(hero)
		remove_child(hero)
		get_node("/root/Main/World/Heroes").add_child(hero)
		hero.recruit(pos)

func remove_hero(hero: Hero):
	if hero in active_heroes:
		active_heroes.erase(hero)
		available_heroes.append(hero)
		get_node("/root/Main/GUI").remove_hero(hero)
		get_node("/root/Main/World/Heroes").remove_child(hero)
		add_child(hero)
		hero.dismiss()

func get_random_hero():
	if len(active_heroes) < 4:
		return available_heroes.pick_random()
	else:
		return null

func select_hero(hero: Hero):
	for h in active_heroes:
		if h == hero:
			h.state_machine.transition_to_state("Selected")
		else:
			h.state_machine.transition_to_state("Idle")
