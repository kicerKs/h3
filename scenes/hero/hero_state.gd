extends State
class_name HeroState

const IDLE = "Idle"
const SELECTED = "Selected"
const MOVING = "Moving"

var hero: Hero

func _ready() -> void:
	await owner.ready
	hero = owner as Hero
