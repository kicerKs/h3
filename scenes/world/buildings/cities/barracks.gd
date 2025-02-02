extends CityBuilding

@export_category("Dwelling")
@export var unit: MobAttributes

var available_to_recruit = 0

func enter():
	entered.emit(self, get_parent().get_parent().visiting_hero, unit, available_to_recruit)

func connect_signals():
	TurnSystem.connect("new_week", growth)
	growth()

func growth():
	available_to_recruit += unit.growth
