extends Node
class_name CityBuilding

@export_category("Basic info")
@export var building_name: String
@export var texture: Texture2D
@export var tooltip: String

@export_category("Building")
@export var building_costs: Array[BuildingCost]
