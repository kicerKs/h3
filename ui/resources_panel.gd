extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.Resources.connect("resources_changed", update_values)
	setup_values()

func update_values(type: GameResources.ResourceTypes, new_value: int):
	match type:
		GameResources.ResourceTypes.WOOD:
			%WoodCount.text = str(new_value)
		GameResources.ResourceTypes.METAL:
			%MetalCount.text = str(new_value)
		GameResources.ResourceTypes.COAL:
			%CoalCount.text = str(new_value)
		GameResources.ResourceTypes.PSI_CRYSTAL:
			%PsiCount.text = str(new_value)
		GameResources.ResourceTypes.GASOLINE:
			%GasolineCount.text = str(new_value)
		GameResources.ResourceTypes.SILICON:
			%SiliconCount.text = str(new_value)
		GameResources.ResourceTypes.CREDITS:
			%CreditsCount.text = str(new_value)

func setup_values():
	%WoodCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.WOOD))
	%MetalCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.METAL))
	%CoalCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.COAL))
	%PsiCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.PSI_CRYSTAL))
	%GasolineCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.GASOLINE))
	%SiliconCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.SILICON))
	%CreditsCount.text = str(Game.Resources.get_resource_count(GameResources.ResourceTypes.CREDITS))
