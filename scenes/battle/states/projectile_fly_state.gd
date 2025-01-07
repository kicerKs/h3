extends BattleTurnState

var last_frame = -1
var animation:bool

func on_enter() -> void:
	animation = true
	last_frame = -1

func on_exit() -> void:
	battle.projectile.position = battle.battle_ground.map_to_local(Vector2i(-10,-10))

func update(_delta: float) -> void:
	if(animation):
		battle.actual_plaing_mob.find_child("Sprite").play("hit")
		if(battle.actual_plaing_mob.find_child("Sprite").frame == 0 and last_frame > 0):
			battle.actual_plaing_mob.find_child("Sprite").stop()
			battle.actual_plaing_mob.find_child("Sprite").animation = "Idle"
			battle.actual_plaing_mob.find_child("Sprite").frame = 0
			animation = false
	elif(battle.projectile.position != battle.target.position):
		battle.projectile.visible = true
		battle.projectile.global_position = battle.projectile.global_position.move_toward(battle.target.position, 20)
	else:
		battle.fight(true)
		change_state.emit(SELECTED)
	last_frame = battle.actual_plaing_mob.find_child("Sprite").frame
	

func physics_update(_delta: float) -> void:
	pass
