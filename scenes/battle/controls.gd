extends Control

signal wait_button_signal()
signal defend_button_signal()
signal surrender_button_clicked()
signal retreat_button_clicked()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wait_button_clicked():
	wait_button_signal.emit()

func defend_button_clicked():
	defend_button_signal.emit()
