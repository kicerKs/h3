extends BattleTurnState

var last_frame = -1

func on_enter() -> void:
	last_frame = -1
	if(battle.actual_plaing_mob.walking_path.size() != 0):
		change_state.emit(MOVING)
	else:
		flip_mob()

func on_exit() -> void:
	pass

func update(_delta: float) -> void:
	battle.actual_plaing_mob.find_child("Sprite").play("hit")
	if(battle.actual_plaing_mob.find_child("Sprite").frame == 0 and last_frame > 0):
		battle.actual_plaing_mob.find_child("Sprite").stop()
		battle.actual_plaing_mob.find_child("Sprite").animation = "Idle"
		battle.actual_plaing_mob.find_child("Sprite").frame = 0
		battle.fight()
		change_state.emit(COUNTERATTACK)
	last_frame = battle.actual_plaing_mob.find_child("Sprite").frame

func physics_update(_delta: float) -> void:
	pass

func flip_mob():
	if(battle.actual_plaing_mob!= null and battle.target!= null):
		if(battle.actual_plaing_mob.position.x > battle.target.position.x):
			battle.actual_plaing_mob.find_child("Sprite").flip_h = true
		else:
			battle.actual_plaing_mob.find_child("Sprite").flip_h = false
