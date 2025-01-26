extends Camera2D

@export var scroll_speed = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("scroll_down"):
		position.y += scroll_speed * delta
	if Input.is_action_pressed("scroll_up"):
		position.y -= scroll_speed * delta
	if Input.is_action_pressed("scroll_left"):
		position.x -= scroll_speed * delta
	if Input.is_action_pressed("scroll_right"):
		position.x += scroll_speed * delta
	position.x = clamp(position.x, limit_left+get_viewport().size.x/2, limit_right-get_viewport().size.x/2)
	position.y = clamp(position.y, limit_top+get_viewport().size.y/2, limit_bottom-get_viewport().size.y/2)
