extends CityBuilding

@export_category("Dwelling")
@export var unit: MobAttributes

var available_to_recruit = 10

func enter():
	entered.emit(self, get_parent().get_parent().visiting_hero, unit, available_to_recruit)
