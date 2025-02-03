extends Control

var city: City
var hero: Hero

var selected_unit: int

@onready var townhall_cost_nodes = [[%TownHallResourceIcon1, %TownHallResourceCount1],[%TownHallResourceIcon2, %TownHallResourceCount2],[%TownHallResourceIcon3, %TownHallResourceCount3]]
@onready var treasury_cost_nodes = [[%TreasuryResourceIcon1, %TreasuryResourceCount1],[%TreasuryResourceIcon2, %TreasuryResourceCount2],[%TreasuryResourceIcon3, %TreasuryResourceCount3]]
@onready var spaceport_cost_nodes = [[%SpaceportResourceIcon1, %SpaceportResourceCount1], [%SpaceportResourceIcon2, %SpaceportResourceCount2], [%SpaceportResourceIcon3, %SpaceportResourceCount3]]
@onready var marketplace_cost_nodes = [[%MarketplaceResourceIcon1, %MarketplaceResourceCount1], [%MarketplaceResourceIcon2, %MarketplaceResourceCount2], [%MarketplaceResourceIcon3, %MarketplaceResourceCount3]]
@onready var tavern_cost_nodes = [[%TavernResourceIcon1, %TavernResourceCount1], [%TavernResourceIcon2, %TavernResourceCount2], [%TavernResourceIcon3, %TavernResourceCount3]]
@onready var barracks_cost_nodes = [[%BarracksResourceIcon1, %BarracksResourceCount1], [%BarracksResourceIcon2, %BarracksResourceCount2], [%BarracksResourceIcon3, %BarracksResourceCount3]]
@onready var sniperrange_cost_nodes = [[%SniperRangeResourceIcon1, %SniperRangeResourceCount1], [%SniperRangeResourceIcon2, %SniperRangeResourceCount2], [%SniperRangeResourceIcon3, %SniperRangeResourceCount3]]
@onready var workshop_cost_nodes = [[%WorkshopResourceIcon1, %WorkshopResourceCount1], [%WorkshopResourceIcon2, %WorkshopResourceCount2], [%WorkshopResourceIcon3, %WorkshopResourceCount3]]
@onready var academy_cost_nodes = [[%AcademyResourceIcon1, %AcademyResourceCount1], [%AcademyResourceIcon2, %AcademyResourceCount2], [%AcademyResourceIcon3, %AcademyResourceCount3]]
@onready var factory_cost_nodes = [[%FactoryResourceIcon1, %FactoryResourceCount1], [%FactoryResourceIcon2, %FactoryResourceCount2], [%FactoryResourceIcon3, %FactoryResourceCount3]]
@onready var assemblyline_cost_nodes = [[%AssemblyLineResourceIcon1, %AssemblyLineResourceCount1], [%AssemblyLineResourceIcon2, %AssemblyLineResourceCount2], [%AssemblyLineResourceIcon3, %AssemblyLineResourceCount3]]
@onready var angelportal_cost_nodes = [[%AngelPortalResourceIcon1, %AngelPortalResourceCount1], [%AngelPortalResourceIcon2, %AngelPortalResourceCount2], [%AngelPortalResourceIcon3, %AngelPortalResourceCount3]]

func show_city_screen(c: City, h: Hero):
	if self.visible == true:
		Game.HeroManager.pause_selected_hero()
	self.visible = true
	city = c
	c.townhall.connect("builded", draw_all_buildings)
	c.treasury.connect("builded", draw_all_buildings)
	c.spaceport.connect("builded", draw_all_buildings)
	c.marketplace.connect("builded", draw_all_buildings)
	c.tavern.connect("builded", draw_all_buildings)
	c.barracks.connect("builded", draw_all_buildings)
	c.sniper_range.connect("builded", draw_all_buildings)
	c.workshop.connect("builded", draw_all_buildings)
	c.academy.connect("builded", draw_all_buildings)
	c.factory.connect("builded", draw_all_buildings)
	c.assembly_line.connect("builded", draw_all_buildings)
	c.angel_portal.connect("builded", draw_all_buildings)
	if h != null:
		hero = h
		hero.connect("army_changed", redraw_army)
		%HeroIcon.texture = hero.attributes.icon
	draw_all_buildings()
	redraw_army()

func draw_all_buildings():
	draw_building(city.townhall, %TownHallButton, townhall_cost_nodes)
	draw_building(city.treasury, %TreasuryButton, treasury_cost_nodes)
	draw_building(city.spaceport, %SpaceportButton, spaceport_cost_nodes)
	draw_building(city.marketplace, %MarketplaceButton, marketplace_cost_nodes)
	draw_building(city.tavern, %TavernButton, tavern_cost_nodes)
	draw_building(city.barracks, %BarracksButton, barracks_cost_nodes)
	draw_building(city.sniper_range, %SniperRangeButton, sniperrange_cost_nodes)
	draw_building(city.workshop, %WorkshopButton, workshop_cost_nodes)
	draw_building(city.academy, %AcademyButton, academy_cost_nodes)
	draw_building(city.factory, %FactoryButton, factory_cost_nodes)
	draw_building(city.assembly_line, %AssemblyLineButton, assemblyline_cost_nodes)
	draw_building(city.angel_portal, %AngelPortalButton, angelportal_cost_nodes)

func draw_building(building: CityBuilding, but: Button, resource_nodes: Array):
	but.icon = building.texture
	but.tooltip_text = building.tooltip
	for el in resource_nodes:
		el[0].visible = false
		el[1].visible = false
	if !building.is_built:
		for i in range(len(building.building_costs)):
			resource_nodes[i][0].texture = GameResources.get_resource_icon(building.building_costs[i].resource)
			resource_nodes[i][0].visible = true
			resource_nodes[i][1].text = str(building.building_costs[i].amount)
			resource_nodes[i][1].visible = true

func redraw_army():
	%HeroContainer.visible = true
	if hero != null:
		if hero.army[0].mob != null:
			%Army1.icon = hero.army[0].mob.icon
			%Army1.text = str(hero.army[0].stack)
		else:
			%Army1.icon = Texture2D.new()
			%Army1.text = ""
		if hero.army[1].mob != null:
			%Army2.icon = hero.army[1].mob.icon
			%Army2.text = str(hero.army[1].stack)
		else:
			%Army2.icon = Texture2D.new()
			%Army2.text = ""
		if hero.army[2].mob != null:
			%Army3.icon = hero.army[2].mob.icon
			%Army3.text = str(hero.army[2].stack)
		else:
			%Army3.icon = Texture2D.new()
			%Army3.text = ""
		if hero.army[3].mob != null:
			%Army4.icon = hero.army[3].mob.icon
			%Army4.text = str(hero.army[3].stack)
		else:
			%Army4.icon = Texture2D.new()
			%Army4.text = ""
		if hero.army[4].mob != null:
			%Army5.icon = hero.army[4].mob.icon
			%Army5.text = str(hero.army[4].stack)
		else:
			%Army5.icon = Texture2D.new()
			%Army5.text = ""
		if hero.army[5].mob != null:
			%Army6.icon = hero.army[5].mob.icon
			%Army6.text = str(hero.army[5].stack)
		else:
			%Army6.icon = Texture2D.new()
			%Army6.text = ""
		if hero.army[6].mob != null:
			%Army7.icon = hero.army[6].mob.icon
			%Army7.text = str(hero.army[6].stack)
		else:
			%Army7.icon = Texture2D.new()
			%Army7.text = ""
	else:
		%HeroContainer.visible = false

func _on_army_1_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 0
		else:
			hero.swap_units(selected_unit, 0)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_2_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 1
		else:
			hero.swap_units(selected_unit, 1)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_3_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 2
		else:
			hero.swap_units(selected_unit, 2)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_4_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 3
		else:
			hero.swap_units(selected_unit, 3)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_5_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 4
		else:
			hero.swap_units(selected_unit, 4)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_6_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 5
		else:
			hero.swap_units(selected_unit, 5)
			selected_unit = -1
			%Army1.release_focus()

func _on_army_7_pressed() -> void:
	if hero != null:
		if selected_unit == -1:
			selected_unit = 6
		else:
			hero.swap_units(selected_unit, 6)
			selected_unit = -1
			%Army1.release_focus()

func _on_button_exit_pressed() -> void:
	Game.HeroManager.unpause_selected_hero()
	self.visible = false
	city.townhall.disconnect("builded", draw_all_buildings)
	city.treasury.disconnect("builded", draw_all_buildings)
	city.spaceport.disconnect("builded", draw_all_buildings)
	city.marketplace.disconnect("builded", draw_all_buildings)
	city.tavern.disconnect("builded", draw_all_buildings)
	city.barracks.disconnect("builded", draw_all_buildings)
	city.sniper_range.disconnect("builded", draw_all_buildings)
	city.workshop.disconnect("builded", draw_all_buildings)
	city.academy.disconnect("builded", draw_all_buildings)
	city.factory.disconnect("builded", draw_all_buildings)
	city.assembly_line.disconnect("builded", draw_all_buildings)
	city.angel_portal.disconnect("builded", draw_all_buildings)
	get_parent().find_child("RightPanel").process_mode = Node.PROCESS_MODE_INHERIT
	hero = null

func _on_town_hall_button_pressed() -> void:
	city.townhall.on_click()

func _on_treasury_button_pressed() -> void:
	city.treasury.on_click()

func _on_spaceport_button_pressed() -> void:
	city.spaceport.on_click()

func _on_marketplace_button_pressed() -> void:
	city.marketplace.on_click()

func _on_tavern_button_pressed() -> void:
	city.tavern.on_click()

func _on_barracks_button_pressed() -> void:
	city.barracks.on_click()

func _on_sniper_range_button_pressed() -> void:
	city.sniper_range.on_click()

func _on_workshop_button_pressed() -> void:
	city.workshop.on_click()

func _on_academy_button_pressed() -> void:
	city.academy.on_click()

func _on_factory_button_pressed() -> void:
	city.factory.on_click()

func _on_assembly_line_button_pressed() -> void:
	city.assembly_line.on_click()

func _on_angel_portal_button_pressed() -> void:
	city.angel_portal.on_click()
