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
var selected_hero: Hero
var paused_from: int = 0

func _ready():
	pass

func recruit_hero(hero: Hero, pos: Vector2):
	if hero in available_heroes and len(active_heroes) < 4:
		available_heroes.erase(hero)
		active_heroes.append(hero)
		remove_child(hero)
		get_node("/root/Main/World/Heroes").add_child(hero)
		hero.recruit(pos)
		get_node("/root/Main/GUI").add_hero(hero)
		select_hero(hero)

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

func get_random_hero_selection():
	if len(active_heroes) < 4:
		var hero = get_random_hero()
		var hero2 = get_random_hero()
		while hero == hero2:
			hero2 = get_random_hero()
		return [hero, hero2]
	return null

func can_recruit_hero():
	if len(active_heroes) < 4:
		return true
	return false

func select_hero(hero: Hero):
	for h in active_heroes:
		if h == hero:
			h.state_machine.transition_to_state("Selected")
			selected_hero = h
		else:
			h.state_machine.transition_to_state("Idle")

func pause_selected_hero():
	print("Pause")
	if paused_from == 0:
		selected_hero.state_machine.transition_to_state("Idle")
	paused_from += 1

func unpause_selected_hero():
	print("unpause")
	paused_from -= 1
	if paused_from == 0:
		selected_hero.state_machine.transition_to_state("Selected")
