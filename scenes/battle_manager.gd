extends Node

var battle: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initialize_battle(hero:Hero, oponents:Array[ArmyUnit], obstacles:Dictionary):
	var main = find_parent("Main")
	battle = Battle.new_battle(hero, oponents, obstacles)
	battle.battle_end.connect(end_battle)
	
	#połączyć sygnał powrotu bohatera do zamku w return_hero_to_castle(hero) signal
	
	main.add_child(battle)
	main.find_child("BattleCamera",true,false).make_current()
	(main.find_child("GUI") as CanvasLayer).visible = false
	pass


func end_battle(hero: Hero, win: bool):
	var main = find_parent("Main")
	main.find_child("MainCamera",true,false).make_current()
	main.remove_child(battle)
	(main.find_child("GUI") as CanvasLayer).visible = true
	Input.set_custom_mouse_cursor(null)
	if win:
		pass #przypisać do poprzedniego bohater/armi zwróconego bohater/armię
	else:
		pass #zabić bohatera
	pass
