extends Node

var current_day
var current_week
var current_month

# Used by things that refresh daily e.g. adding resources like wood
signal new_day
# Used by things that refresh weekly e.g. new units available to recruit
signal new_week
# Used by GUI elements to update
signal update_turn(day, week, month)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_day = 1
	current_week = 1
	current_month = 1
	update_turn.emit(current_day, current_week, current_month)
	new_day.emit()

# Use it e.g. when loading a new game from file
func setup_turn_system(day, week, month):
	current_day = day
	current_week = week
	current_month = month
	update_turn.emit(current_day, current_week, current_month)
	new_day.emit()

# Called after clicking new turn in GUI
func new_turn():
	current_day += 1
	if current_day > 7:
		current_day = 1
		current_week += 1
		new_week.emit()
		if current_week > 4:
			current_week = 1
			current_month += 1
	update_turn.emit(current_day, current_week, current_month)
	new_day.emit()
