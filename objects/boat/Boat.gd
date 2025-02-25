class_name Boat
extends StaticBody2D

signal on_leave_level()

var can_enter = false

func _on_enter():
	if can_enter:
		on_leave_level.emit()
