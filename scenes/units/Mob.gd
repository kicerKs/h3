class_name Mob extends Node2D

signal mob_play(Mob)
signal mob_ended()
signal mob_clicked(Mob, Part)

@onready var map_reference = $"../../Battleground" 
enum MobStatus {Play, Wait, Dead}
enum Part {LU,RU,LM,RM,LD,RD}

var scene: PackedScene

var walking_path: Array[Vector2i]
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
		
var status = MobStatus.Wait:
	set(value):
		if(value == MobStatus.Play):
			light_up()
			mob_play.emit(self)
		if(value == MobStatus.Wait):
			light_down()
			mob_ended.emit()
		status = value

var attack = 1
var defence = 1
	#get():
		#return defence + defence_boost*0.20*defence
var damage_min = 1
var damage_max = 1
var hp_base = 1
var hp_stack = 0:
	set(value):
		if(hp_stack != 0):
			stack = ceil(hp_stack/hp_base)
			print(value)
		hp_stack = value
var speed = 1
var growth = 1
var ai_val = 1
var cost = 1
var defence_boost = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#await owner.ready
	#map_reference = owner.get_parent().get_parent().find_child("BattleGround")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not walking_path.is_empty():
		var target_position = map_reference.map_to_local(walking_path.front())
		target_position.y = target_position.y + 40
		global_position = global_position.move_toward(target_position, 20)
		
		if global_position == target_position:
			walking_path.pop_front()
			if walking_path.is_empty():
				status = MobStatus.Wait

func light_up():
	get_child(0).frame = 1
func light_down():
	get_child(0).frame = 0

func _area_event_LU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LU)

func _area_event_RU(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RU)

func _area_event_LM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LM)

func _area_event_RM(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RM)

func _area_event_LD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.LD)

func _area_event_RD(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		mob_clicked.emit(self, Part.RD)

func get_speed() -> int:
	return speed
