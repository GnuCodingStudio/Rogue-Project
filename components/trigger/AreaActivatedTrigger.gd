class_name AreaTrigger
extends Node2D


signal on_activated()
signal on_deactivated()


@export_group("Events", "trigger_")
@export var trigger_activation: bool = true
@export var trigger_deactivation: bool = true


var is_triggering := false:
	set(value):
		if value != is_triggering:
			is_triggering = value
			_on_trigger_change()
		else:
			is_triggering = value


var _players_detected: Array[Player] = []


func _ready() -> void:
	var parent = get_parent()
	assert(parent is Area2D, "Parent of AreaTrigger must be an Area2D")
	var area = parent as Area2D

	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_players_detected.push_back(body)
		is_triggering = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_players_detected.erase(body)
		if _players_detected.is_empty():
			is_triggering = false


func _on_trigger_change() -> void:
	if is_triggering:
		if trigger_activation:
			on_activated.emit()

			var parent = get_parent()
			if parent.has_method("on_activated"):
				parent.on_activated()
	else:
		if trigger_deactivation:
			on_deactivated.emit()

			var parent = get_parent()
			if parent.has_method("on_deactivated"):
				parent.on_deactivated()
