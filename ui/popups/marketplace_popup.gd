extends Control

var resource_give: GameResources.ResourceTypes = 0
var resource_take: GameResources.ResourceTypes = 0

func show_marketplace_popup():
	self.visible = true
	%ResourceGive.selected = 0
	%ResourceTake.selected = 0
	resource_give = 0
	resource_take = 0
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_DISABLED
	get_parent().find_child("CityScreen").process_mode = Node.PROCESS_MODE_DISABLED
	reload()

func reload():
	%HSlider.value = 0
	update_ratio()

func update_ratio():
	var ratio = Game.Resources.exchange_rate(resource_give, 1, resource_take)
	if ratio > 1:
		%Ratio.text = "Ratio: 1:" + str(ratio)
		%HSlider.max_value = Game.Resources.get_resource_count(resource_give)
	else:
		ratio = 1 / ratio
		%Ratio.text = "Ratio: " + str(int(ratio)) + ":1"
		%HSlider.max_value = Game.Resources.get_resource_count(resource_give) / int(ratio)

func _on_resource_give_item_selected(index: int) -> void:
	resource_give = index
	update_ratio()


func _on_resource_take_item_selected(index: int) -> void:
	resource_take = index
	update_ratio()


func _on_h_slider_value_changed(value: int) -> void:
	var ratio = Game.Resources.exchange_rate(resource_give, 1, resource_take)
	if ratio < 1:
		ratio = int(1 / ratio)
		%Total.text = "Total: " + str(ratio*value) + ":" + str(value)
	else:
		%Total.text = "Total: " + str(value) + ":" + str(ratio*value)


func _on_button_exit_pressed() -> void:
	self.visible = false
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_INHERIT
	get_parent().find_child("CityScreen").process_mode = Node.PROCESS_MODE_INHERIT


func _on_button_trade_pressed() -> void:
	var ratio = Game.Resources.exchange_rate(resource_give, 1, resource_take)
	if ratio < 1:
		ratio = int(1 / ratio)
		Game.Resources.exchange(resource_give, ratio*%HSlider.value, resource_take)
	else:
		Game.Resources.exchange(resource_give, %HSlider.value, resource_take)
	reload()
