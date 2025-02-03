class_name DefAnim extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_on_position(position: Vector2):
	self.position = position
	self.visible = true
	frame = 0
	play("default")

func animation_ended():
	self.position = Vector2(-480,-480)
	self.visible = false
