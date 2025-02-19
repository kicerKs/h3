extends Node

var battle: Node

signal battle_conquered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initialize_battle(hero:Hero, oponents:Array[ArmyUnit]):
	hero.state_machine.transition_to_state("Idle")
	var main = find_parent("Main")
	battle = Battle.new_battle(hero, oponents)
	battle.battle_end.connect(end_battle)
	battle.connect("return_hero_to_castle", Game.HeroManager.remove_hero)
	#połączyć sygnał powrotu bohatera do zamku w return_hero_to_castle(hero) signal
	
	main.add_child(battle)
	main.find_child("BattleCamera",true,false).make_current()
	(main.find_child("GUI") as CanvasLayer).visible = false
	pass


func end_battle(hero: Hero, win: bool):
	hero.reset_luck_morale_bonuses()
	var main = find_parent("Main")
	main.find_child("MainCamera",true,false).make_current()
	(main.find_child("GUI") as CanvasLayer).visible = true
	Input.set_custom_mouse_cursor(null)
	if win:
		hero.state_machine.transition_to_state("Selected")
		battle_conquered.emit()
		pass #przypisać do poprzedniego bohater/armi zwróconego bohater/armię
	else:
		battle.emit_signal("return_hero_to_castle", hero)
	main.remove_child(battle)
