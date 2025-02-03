extends State
class_name BattleTurnState

const SELECTED = "Selected"
const MOVING = "Moving"
const ATTACK = "Attack"
const COUNTERATTACK = "Counterattack"
const PROJECTILE_FLY = "ProjectileFly"

var battle: Battle

func _ready() -> void:
	await owner.ready
	battle = owner as Battle
