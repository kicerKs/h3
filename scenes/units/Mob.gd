class_name Mob extends Node2D

signal mob_play()
signal mob_ended()
signal mob_clicked(Mob, Part)
signal mob_info_show(Mob)
signal mob_info_hide
signal hit_box_input(Mob, Part)

enum Part {LU,RU,LM,RM,LD,RD,NONE}

var scene: PackedScene

var walking_path: Array[Vector2i]#:
	#set(value):
		#print(value)
		#walking_path = value
var player = true
var flying = false:
	get():
		return mob_attributes.flying
var distant = false:
	get():
		return mob_attributes.distant
var counterattack = true
var stack = 0:
	set(value):
		stack = value
		if(hp_stack == 0):
			hp_stack = value*hp_base
		%Stack.text = str(stack)

var mob_attributes: MobAttributes
var attack = 1:
	get():
		return mob_attributes.attack
var defense = 1:
	get():
		return mob_attributes.defense * (1.2 if(defense_boost)else 1)
var damage_min = 1:
	get():
		return mob_attributes.damage_min
var damage_max = 1:
	get():
		return mob_attributes.damage_max
var hp_base = 1:
	get():
		return mob_attributes.hp_base
var hp_stack = 0:
	set(value):
		if(hp_stack != 0):
			stack = ceil(float(value)/float(hp_base))
		hp_stack = value
var speed = 1:
	get():
		return mob_attributes.speed
var growth = 1:
	get():
		return mob_attributes.growth
var ai_val = 1:
	get():
		return mob_attributes.ai_val
var cost = 1:
	get():
		return mob_attributes.cost
var defense_boost = false
var mob_number = -1:
	get():
		return mob_attributes.mob_number
var morale = 1
var mob_name = "":
	get():
		return mob_attributes.mob_name

func _ready():
	$Sprite.sprite_frames = mob_attributes.animations

func _process(delta: float) -> void:
	pass

func center_label():
	%Stack.position.x = -42
	%Stack.position.y = 50

func side_label():
	%Stack.position.x = 35
	%Stack.position.y = -50

func _area_event_LU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.LU)

func _area_event_RU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.RU)

func _area_event_LM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.LM)

func _area_event_RM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.RM)

func _area_event_LD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.LD)

func _area_event_RD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	_area_event(event, Part.RD)

func _area_event(event: InputEvent, part: Part):
	hit_box_input.emit(self,part)
	if event is InputEventMouseButton and event.is_action("mouse_click_right") and event.is_pressed():
		_right_button_click()
	elif event is InputEventMouseButton and event.is_action("mouse_click_right") and event.is_released():
		_right_button_released()
	elif event is InputEventMouseButton and event.is_action("mouse_click_left") and event.is_pressed():
		mob_clicked.emit(self, part)

func _right_button_click():
	mob_info_show.emit(self)

func _right_button_released():
	mob_info_hide.emit()

func get_speed() -> int:
	return speed
