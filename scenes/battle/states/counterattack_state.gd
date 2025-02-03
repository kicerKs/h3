extends BattleTurnState

var last_frame = -1

func on_enter() -> void:
	last_frame = -1
	if(battle.target  != null and battle.target.counterattack):
		flip_mob()
	if(battle.target != null and !battle.target.counterattack):
		battle.target = null

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	if(battle.target != null and battle.target.counterattack and battle.target.hp_stack>0 and battle.actual_plaing_mob.hp_stack>0):
		battle.target.find_child("Sprite").play("hit")
		if(battle.target.find_child("Sprite").frame == 0 and last_frame > 0):
			battle.target.find_child("Sprite").stop()
			battle.target.find_child("Sprite").animation = "Idle"
			battle.target.find_child("Sprite").frame = 0
			battle.counterattack()
			battle.target.counterattack = false
			if(battle.target.player):
				battle.target.find_child("Sprite").flip_h = false
			else:
				battle.target.find_child("Sprite").flip_h = true
			battle.target = null
			change_state.emit(SELECTED)
		if(battle.target != null):
			last_frame = battle.target.find_child("Sprite").frame
	else:
		change_state.emit(SELECTED)

func physics_update(_delta: float) -> void:
	pass

func flip_mob():
	if(battle.actual_plaing_mob!= null and battle.target!= null):
		if(battle.target.position.x > battle.actual_plaing_mob.position.x):
			battle.target .find_child("Sprite").flip_h = true
		else:
			battle.target .find_child("Sprite").flip_h = false
