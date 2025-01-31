extends CanvasLayer

@export var gui_heroes: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TurnSystem.connect("update_turn", _on_turn_system_update_turn)
	_on_turn_system_update_turn(TurnSystem.current_day, TurnSystem.current_week, TurnSystem.current_month)
	pass # Replace with function body.

func _on_turn_system_update_turn(day: Variant, week: Variant, month: Variant) -> void:
	%MonthLabel.text = "Miesiac: " + str(month)
	%WeekLabel.text = "Tydzień: " + str(week)
	%DayLabel.text = "Dzień: " + str(day)

func _on_button_new_turn_pressed() -> void:
	TurnSystem.new_turn()

func get_gui_size():
	return Vector2($RightPanel.size.x, $BottomPanel.size.y)

func add_hero(hero: Hero):
	gui_heroes.add_hero(hero)

func remove_hero(hero: Hero):
	gui_heroes.remove_hero(hero)
