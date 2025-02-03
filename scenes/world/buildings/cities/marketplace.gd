extends CityBuilding

signal open_marketplace

func enter():
	open_marketplace.emit()

func connect_signals():
	connect("open_marketplace", get_node("/root/Main/GUI/MarketplacePopup").show_marketplace_popup)
