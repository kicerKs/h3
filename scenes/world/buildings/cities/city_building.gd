extends Node2D
class_name CityBuilding

@export_category("Basic info")
@export var building_name: String
@export var texture: Texture2D:
	get():
		if !is_built:
			return load("res://assets/piwerko.png")
		return texture
@export var tooltip: String

@export_category("Building")
@export var is_built: bool
@export var building_costs: Array[BuildingCost]

signal entered
signal try_to_build
signal cant_build
signal builded

func _ready():
	if is_built:
		connect_signals()

func enter():
	pass

func connect_signals():
	pass

func build():
	print("IM BUILDING MYSELF")
	for bc in building_costs:
		Game.Resources.add_resource(bc.resource, -1 * bc.amount)
	is_built = true
	connect_signals()
	builded.emit()

func on_click():
	if is_built:
		enter()
	else:
		if !can_build():
			cant_build.emit(self)
		else:
			try_to_build.emit(self)

func can_build() -> bool:
	for bc in building_costs:
		if Game.Resources.get_resource_count(bc.resource) < bc.amount:
			return false
	return true
