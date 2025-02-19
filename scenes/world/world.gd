extends Node2D

var battles = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().connect("size_changed", set_camera_boundaries)
	set_camera_boundaries()
	Game.HeroManager.recruit_hero(Game.HeroManager.get_random_hero(), $Cities/City.global_position+Vector2(0,64))
	$MainCamera.focus($Heroes.get_children()[0].position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_battle():
	battles += 1

func remove_battle():
	print("remove")
	battles -= 1
	print("battles")
	if battles == 0:
		get_node("/root/Main/GUI/InfoPopup").show_victory()

func set_camera_boundaries():
	var rec = $MapMoving.get_used_rect()
	var off = Vector2i(rec.size.x*64, rec.size.y*64)
	print(off)
	$MainCamera.limit_top = 0 - (get_viewport().size.y/2)
	$MainCamera.limit_bottom = off.y + (get_viewport().size.y/2)
	$MainCamera.limit_left = 0 - (get_viewport().size.x/2)
	$MainCamera.limit_right = off.x + (get_viewport().size.x/2)

func remove_combat(pos: Vector2):
	var tilemap: TileMapLayer = $MapMoving
	tilemap.set_cell(pos, 1)
