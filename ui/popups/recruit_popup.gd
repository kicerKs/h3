extends Control

var is_unit_resource: bool = false
var unit_resource: GameResources.ResourceTypes = GameResources.ResourceTypes.GASOLINE
var unit_cost_resources = 2
var maximum_to_recruit = 0
var unit: MobAttributes
var hero: Hero
var node: Node2D

func _ready():
	for el in get_tree().get_nodes_in_group("Dwellings"):
		el.connect("entered", nowy)

func nowy(n: Node2D, h: Hero, u: MobAttributes, maximum: int):
	self.visible = true
	self.unit = u
	self.hero = h
	self.node = n
	maximum_to_recruit = maximum
	%Title.text = "Recruit " + unit.mob_name
	%UnitIcon.texture = unit.standing_frame
	%Recruit.text = "0"
	%Available.text = str(maximum_to_recruit)
	if !unit.have_resource_cost:
		%ResourceIcon1.visible = false
		%ResourceIcon2.visible = false
		%ResourcePerTroop.visible = false
		%ResourceTotal.visible = false
	else:
		%ResourceIcon1.visible = true
		%ResourceIcon2.visible = true
		%ResourcePerTroop.visible = true
		%ResourceTotal.visible = true
		%ResourceIcon1.texture = GameResources.get_resource_icon(unit.resource_cost)
		%ResourceIcon2.texture = GameResources.get_resource_icon(unit.resource_cost)
		%ResourcePerTroop.text = "2"
	%CreditsPerTroop.text = str(unit.cost)
	setup_slider()

func _on_h_slider_value_changed(value: float) -> void:
	%Recruit.text = str(value)
	%Available.text = str(maximum_to_recruit - value)
	%CreditsTotal.text = str(value * unit.cost)
	if unit.have_resource_cost:
		%ResourceTotal.text = str(value * 2)

func _on_button_max_pressed() -> void:
	%Slider.value = %Slider.max_value


func _on_button_buy_pressed() -> void:
	if %Slider.value > 0:
		Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, -1 * %Slider.value * unit.cost)
		if unit.have_resource_cost:
			Game.Resources.add_resource(unit.resource_cost, -1 * %Slider.value * 2)
		hero.add_units_to_army(unit, %Slider.value)
		node.available_to_recruit -= %Slider.value
		self.nowy(node, hero, unit, maximum_to_recruit - %Slider.value)

func _on_button_cancel_pressed() -> void:
	self.visible = false

func setup_slider():
	print(int(Game.Resources.get_resource_count(GameResources.ResourceTypes.CREDITS)/unit.cost))
	%Slider.max_value = min(maximum_to_recruit, int(Game.Resources.get_resource_count(GameResources.ResourceTypes.CREDITS)/unit.cost))
	if unit.have_resource_cost:
		%Slider.max_value = min(%Slider.max_value, int(Game.Resources.get_resource_count(unit.resource_cost)/2))
	%Slider.value = 0
	%CreditsTotal.text = "0"
	%ResourceTotal.text = "0"
