class_name NearestPlayerTargetingBehavior
extends Area2D


var _mob: Mob


func _ready() -> void:
	assert(get_parent() is Mob)
	_mob = get_parent()


func _process(delta: float) -> void:
	var targeted_player = _find_nearest_player()
	if targeted_player:
		_mob.targeted_players = [targeted_player]
	else:
		_mob.targeted_players = []


func _find_nearest_player() -> Player:
	var nearest_player: Player
	var nearest_distance: float

	for body in get_overlapping_bodies():
		if body is Player && body.isAlive:
			var distance = global_position.distance_to(body.global_position)
			if nearest_player == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_player = body

	return nearest_player
