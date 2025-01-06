class_name Controls extends Control

signal wait_button_signal()
signal defend_button_signal()
signal surrender_button_signal()
signal retreat_button_signal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wait_button_clicked():
	wait_button_signal.emit()

func defend_button_clicked():
	defend_button_signal.emit()

func surrender_button_clicked():
	surrender_button_signal.emit()

func retreat_button_clicked():
	retreat_button_signal.emit()

func lock_wait_button():
	(find_child("WaitButton") as Button).disabled = true

func lock_all_buttons():
	(find_child("WaitButton") as Button).disabled = true
	(find_child("DefendButton") as Button).disabled = true
	(find_child("SurrenderButton") as Button).disabled = true
	(find_child("RetreatButton") as Button).disabled = true

func unlock_all_buttons():
	(find_child("WaitButton") as Button).disabled = false
	(find_child("DefendButton") as Button).disabled = false
	(find_child("SurrenderButton") as Button).disabled = false
	(find_child("RetreatButton") as Button).disabled = false

func add_bar_to_icons():
	var bar = ColorRect.new()
	bar.color = Color(0.95,0.95,0.95,1.0)
	bar.custom_minimum_size = Vector2(7,80)
	$HBoxContainer.add_child(bar)

func add_mob_icon(mob: Mob):
	var head_rect = TextureRect.new()
	head_rect.texture = get_head(mob.mob_number, load("res://assets/heads.png"))
	head_rect.custom_minimum_size = Vector2(50,75)
	
	var panel = CenterContainer.new()
	panel.custom_minimum_size = Vector2(60,80)
	var color_rect = ColorRect.new()
	color_rect.color = Color(0.2,0.2,0.93,1.0) if mob.player else Color(0.93,0.2,0.2,1.0)
	color_rect.custom_minimum_size = Vector2(60,80)

	panel.add_child(color_rect)
	panel.add_child(head_rect)
	$HBoxContainer.add_child(panel)

func get_head(number: int, heads: CompressedTexture2D) -> AtlasTexture:
	var texture = AtlasTexture.new()
	texture.atlas = heads
	texture.region = Rect2(number*30,0,30,40)
	return texture

func heads_not_empty() -> bool:
	return $HBoxContainer.get_children().size() > 0

func remove_first_head():
	$HBoxContainer.remove_child($HBoxContainer.get_children()[0])

func clear_heads():
	for child in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(child)
