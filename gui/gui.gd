extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_button_pressed() -> void:
	get_parent().get_node("TurnSystem").new_turn()

func _on_turn_system_update_turn(day: Variant, week: Variant, month: Variant) -> void:
	$Label.text = "Month: " + str(month) + " Week: " + str(week) + " Day: " + str(day)
