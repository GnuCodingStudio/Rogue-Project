class_name Clickable
extends Node2D


signal click


var _mouse_hover := false


#region built-in

func _ready() -> void:
	var area_children = find_children("*", "Area2D")
	if area_children.is_empty():
		assert(false, "Clickable must contain Area2D as child")
	if area_children.size() > 1:
		assert(false, "Clickable must only contain ONE Area2D")

	var clickable_area = area_children[0]
	clickable_area.mouse_entered.connect(_mouse_entered)
	clickable_area.mouse_exited.connect(_mouse_exited)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.is_released() and _mouse_hover:
			click.emit()

#endregion built-in


#region signal

func _mouse_entered() -> void:
	_mouse_hover = true
	get_parent().modulate = Color.GRAY


func _mouse_exited() -> void:
	_mouse_hover = false
	get_parent().modulate = Color.WHITE

#endregion signal
