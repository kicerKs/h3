extends Control

signal wait_button_signal()
signal defend_button_signal()
signal surrender_button_signal()
signal retreat_button_signal()

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

func surrender_button_clicked():
	surrender_button_signal.emit()

func retreat_button_clicked():
	retreat_button_signal.emit()

func lock_wait_button():
	(find_child("WaitButton") as Button).disabled = true

func lock_all_buttons():
	(find_child("WaitButton") as Button).disabled = true
	(find_child("DefendButton") as Button).disabled = true
	(find_child("SurrenderButton") as Button).disabled = true
	(find_child("RetreatButton") as Button).disabled = true

func unlock_all_buttons():
	(find_child("WaitButton") as Button).disabled = false
	(find_child("DefendButton") as Button).disabled = false
	(find_child("SurrenderButton") as Button).disabled = false
	(find_child("RetreatButton") as Button).disabled = false
