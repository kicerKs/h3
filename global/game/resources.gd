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
	ResourceTypes.CREDITS: 0,
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
	assert(give != receive)
	match receive:
		ResourceTypes.CREDITS:
			if give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				_resources[receive] += 250 * number
			else:
				_resources[receive] += 500 * number
		ResourceTypes.WOOD, ResourceTypes.METAL:
			if give == ResourceTypes.CREDITS:
				_resources[receive] += int(number/500)
			else:
				_resources[receive] += number * 2
		ResourceTypes.COAL, ResourceTypes.PSI_CRYSTAL, ResourceTypes.SILICON, ResourceTypes.GASOLINE:
			if give == ResourceTypes.CREDITS:
				_resources[receive] += int(number/1000)
			else:
				_resources[receive] += int(number/4)
	_resources[give] -= number
	resources_changed.emit(give, _resources[give])
	resources_changed.emit(receive, _resources[receive])

func exchange_rate(give: ResourceTypes, number: int, receive: ResourceTypes):
	assert(give != receive)
	match receive:
		ResourceTypes.CREDITS:
			if give == ResourceTypes.WOOD or give == ResourceTypes.METAL:
				return 250 * number
			else:
				return 500 * number
		ResourceTypes.WOOD, ResourceTypes.METAL:
			if give == ResourceTypes.CREDITS:
				return int(number/500)
			else:
				return number * 2
		ResourceTypes.COAL, ResourceTypes.PSI_CRYSTAL, ResourceTypes.SILICON, ResourceTypes.GASOLINE:
			if give == ResourceTypes.CREDITS:
				return int(number/1000)
			else:
				return int(number/4)
