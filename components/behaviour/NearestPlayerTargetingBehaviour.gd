class_name NearestPlayerTargetingBehaviour
extends Area2D


var _actor: Actor

func _ready() -> void:
	assert(get_parent() is Actor)
	_actor = get_parent()


func _process(delta: float) -> void:
	var targeted_player = _find_nearest_player()
	if targeted_player:
		_actor.moving_direction = targeted_player.global_position - global_position
	else:
		_actor.moving_direction = Vector2.ZERO


func _find_nearest_player() -> Player:
	var nearest_player: Player
	var nearest_distance: float

	for body in get_overlapping_bodies():
		if body is Player:
			var distance = global_position.distance_to(body.global_position)
			if nearest_player == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_player = body

	return nearest_player
