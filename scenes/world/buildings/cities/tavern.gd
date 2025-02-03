extends CityBuilding

signal recruit
signal cannot_recruit

func enter():
	if Game.HeroManager.can_recruit_hero() and get_parent().get_parent().visiting_hero == null and Game.Resources.get_resource_count(GameResources.ResourceTypes.CREDITS) >= 2500:
		recruit.emit(get_parent().get_parent().position)
	else:
		cannot_recruit.emit()

func connect_signals():
	connect("recruit", get_node("/root/Main/GUI/TavernPopup").show_tavern_popup)
	connect("cannot_recruit", get_node("/root/Main/GUI/InfoPopup").show_tavern_cannot)
