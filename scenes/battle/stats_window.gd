class_name StatsWindow extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func pass_mob(mob: Mob, hero: Hero = null):
	find_child("AttackValue").text = str(mob.attack) + ("" if(hero == null) else "("+str(mob.attack+hero.attack)+")")
	find_child("DefenseValue").text = str(mob.defense) + ("" if(hero == null) else "("+str(mob.defense+hero.defense)+")")
	find_child("DamageValue").text = str(mob.damage_min)+"-"+str(mob.damage_max)
	find_child("HealthValue").text = str(mob.hp_base)
	find_child("HealthLeftValue").text = str(mob.hp_stack%mob.hp_base if (mob.hp_stack%mob.hp_base>0) else mob.hp_base)
	find_child("SpeedValue").text = str(mob.speed)
	find_child("DistantValue").text = "Tak" if(mob.distant) else "Nie"
	find_child("StackValue").text = str(mob.stack)
	find_child("MobNameLabel").text = str(mob.mob_name)
	
	for child in find_child("Background").get_children(true):
		if(child is Mob): find_child("Background").remove_child(child)
	#var mobScene: Node2D = mob.scene.instantiate()
	var scene = load("res://scenes/units/Mob.tscn")
	var mobScene = scene.instantiate()
	mobScene.mob_attributes = mob.mob_attributes
	(mobScene.find_child('Stack') as LineEdit).visible = false

	mobScene.scale = Vector2(1.2, 1.2)
	mobScene.position = Vector2(70, 80)
	mobScene.get_child(0).flip_h = !mob.player
	find_child("Background").add_child(mobScene)
	
	$Window/BorderColor.color = Color(0.2,0.2,0.93,1.0) if mob.player else Color(0.93,0.2,0.2,1.0)

func set_visibility(visible: bool):
	$Window.visible = visible

func set_window_position(position: Vector2):
	$Window.position = position
