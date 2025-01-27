class_name RunToPlayerMovementBehavior
extends Node


var _mob: Mob


func _ready() -> void:
	assert(get_parent() is Mob)
	_mob = get_parent()


func _process(delta: float) -> void:
	if _mob.targeted_players.size() > 0:
		_mob.moving_direction = _mob.targeted_players[0].global_position - _mob.global_position
	else:
		_mob.moving_direction = Vector2.ZERO
