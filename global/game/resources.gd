extends Node
class_name GameResources

signal resources_changed(type, new_value)

enum ResourceTypes{
	WOOD,
	METAL,
	COAL,
	PSI_CRYSTAL,
	GASOLINE,
	SILICON,
	CREDITS,
}

var _resources = {
	ResourceTypes.WOOD: 0,
	ResourceTypes.METAL: 0,
	ResourceTypes.COAL: 0,
	ResourceTypes.PSI_CRYSTAL: 0,
	ResourceTypes.GASOLINE: 0,
	ResourceTypes.SILICON: 0,
	ResourceTypes.CREDITS: 2000,
}

func has_resources(type: ResourceTypes, number: int) -> bool:
	if _resources[type] >= number:
		return true
	return false

func add_resource(type: ResourceTypes, number: int) -> void:
	_resources[type] += number
	resources_changed.emit(type, _resources[type])

func get_resource_count(type: ResourceTypes):
	return _resources[type]

func exchange(give: ResourceTypes, number: int, receive: ResourceTypes):
	if give == receive:
		return
	match receive:
		ResourceTypes.CREDITS:
			if give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				_resources[receive] += 250 * number
			else:
				_resources[receive] += 500 * number
		ResourceTypes.WOOD, ResourceTypes.METAL:
			if give == ResourceTypes.CREDITS:
				_resources[receive] += int(number/500)
			elif give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				_resources[receive] += int(number / 2)
			else:
				_resources[receive] += number * 3
		ResourceTypes.COAL, ResourceTypes.PSI_CRYSTAL, ResourceTypes.SILICON, ResourceTypes.GASOLINE:
			if give == ResourceTypes.CREDITS:
				_resources[receive] += int(number/1000)
			elif give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				_resources[receive] += int(number/4)
			else:
				_resources[receive] += int(number/2)
	_resources[give] -= number
	resources_changed.emit(give, _resources[give])
	resources_changed.emit(receive, _resources[receive])

func exchange_rate(give: ResourceTypes, number: int, receive: ResourceTypes):
	if give == receive:
		return 1
	match receive:
		ResourceTypes.CREDITS:
			if give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				return number * 250
			else:
				return number * 500
		ResourceTypes.WOOD, ResourceTypes.METAL:
			if give == ResourceTypes.CREDITS:
				return number/500.0
			elif give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				return number/2.0
			else:
				return number * 3
		ResourceTypes.COAL, ResourceTypes.PSI_CRYSTAL, ResourceTypes.SILICON, ResourceTypes.GASOLINE:
			if give == ResourceTypes.CREDITS:
				return number/1000.0
			elif give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				return number/4.0
			else:
				return number/2.0

static func get_resource_name(type: ResourceTypes):
	match type:
		ResourceTypes.WOOD:
			return "Wood"
		ResourceTypes.METAL:
			return "Metal"
		ResourceTypes.COAL:
			return "Coal"
		ResourceTypes.PSI_CRYSTAL:
			return "Psi Crystal"
		ResourceTypes.SILICON:
			return "Silicon"
		ResourceTypes.GASOLINE:
			return "Gasoline"
		ResourceTypes.CREDITS:
			return "Credits"

static func get_resource_icon(type: ResourceTypes):
	match type:
		ResourceTypes.WOOD:
			return load("res://assets/Surowce/drewno_puste.png")
		ResourceTypes.METAL:
			return load("res://assets/Surowce/metal_pusty.png")
		ResourceTypes.COAL:
			return load("res://assets/Surowce/wegiel_pusty.png")
		ResourceTypes.PSI_CRYSTAL:
			return load("res://assets/Surowce/kryszal_puste.png")
		ResourceTypes.SILICON:
			return load("res://assets/Surowce/krzem_pusty.png")
		ResourceTypes.GASOLINE:
			return load("res://assets/Surowce/ropa_puste.png")
		ResourceTypes.CREDITS:
			return load("res://assets/Surowce/kredyty_puste.png")
		_:
			return load("res://assets/ph_icon.png")
