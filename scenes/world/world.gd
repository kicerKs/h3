extends Node2D

var resources = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().connect("size_changed", set_camera_boundaries)
	set_camera_boundaries()
	$Heroes/Player.recruit()
	$MainCamera.focus($Heroes/Player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_camera_boundaries():
	var rec = $MapMoving.get_used_rect()
	var off = Vector2i(rec.size.x*64, rec.size.y*64)
	print(off)
	$MainCamera.limit_top = 0 - (get_viewport().size.y/2)
	$MainCamera.limit_bottom = off.y + (get_viewport().size.y/2)
	$MainCamera.limit_left = 0 - (get_viewport().size.x/2)
	$MainCamera.limit_right = off.x + (get_viewport().size.x/2)
