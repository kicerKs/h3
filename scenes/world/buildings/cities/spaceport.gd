extends CityBuilding

func connect_signals():
	TurnSystem.connect("new_day", give_credits)

func give_credits():
	Game.Resources.add_resource(GameResources.ResourceTypes.CREDITS, 1000)
