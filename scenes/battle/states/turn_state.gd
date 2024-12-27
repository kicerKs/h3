extends State
class_name MobState

const IDLE = "Idle"
const SELECTED = "Selected"
const MOVING = "Moving"
const ATTACK = "Attacking"
const DEFEND = "Defending"
const WAIT = "Waiting"

var mob: Mob

func _ready() -> void:
	await owner.ready
	mob = owner as Mob
