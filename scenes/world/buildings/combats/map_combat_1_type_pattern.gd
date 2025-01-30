extends Sprite2D

@export var mob: MobAttributes
@export var number: int

func _ready():
	self.texture = mob.animations.get_frame_texture("Idle", 0)
