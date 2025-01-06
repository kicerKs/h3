class_name Mob extends Node2D

signal mob_play()
signal mob_ended()
signal mob_clicked(Mob, Part)
signal hit_box_input(Mob, Part)

@onready var map_reference = $"../../Battleground" 
enum Part {LU,RU,LM,RM,LD,RD,NONE}

var scene: PackedScene

var walking_path: Array[Vector2i]#:
	#set(value):
		#print(value)
		#walking_path = value
var player = true
var flying = false
var distant = false
var counterattack = true
var stack = 0:
	set(value):
		stack = value
		if(hp_stack == 0):
			hp_stack = value*hp_base
		$Stack.text = str(stack)

var attack = 1
var defense = 1:
	get():
		return defense * (1.2 if(defense_boost)else 1)
var damage_min = 1
var damage_max = 1
var hp_base = 1
var hp_stack = 0:
	set(value):
		if(hp_stack != 0):
			stack = ceil(float(value)/float(hp_base))
		hp_stack = value
var speed = 1
var growth = 1
var ai_val = 1
var cost = 1
var defense_boost = false
var mob_number = -1

func _process(delta: float) -> void:
	pass

func _area_event_LU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.LU)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LU)

func _area_event_RU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.RU)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RU)

func _area_event_LM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.LM)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LM)

func _area_event_RM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.RM)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RM)

func _area_event_LD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.LD)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LD)

func _area_event_RD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	hit_box_input.emit(self,Part.RD)
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RD)

func get_speed() -> int:
	return speed
