class_name Idle extends State

@onready var detection_area: Area2D = %DetectionArea
@onready var states: States = $".."
@onready var follow: State = $"../Follow"

var _player_detected := false

func transition() -> void:
	super.transition()
	if _player_detected:
		states.change_state(follow)

func _on_body_detected(body: Node2D) -> void:
	if body is Player:
		_player_detected = true
