extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rec = $TileMapLayer.get_used_rect()
	var off = Vector2i(rec.size.x*64, rec.size.y*64)
	print(off)
	$MainCamera.limit_top = 0
	$MainCamera.limit_bottom = off.y
	$MainCamera.limit_left = 0
	$MainCamera.limit_right = off.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
