extends Node

var _projectile: Attack

func _ready() -> void:
	assert(get_parent() is Attack)
	_projectile = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _projectile.targeted_direction != Vector2.ZERO:
		
		var movement = _projectile.targeted_direction.normalized() * delta * 400
		_projectile.position += movement
		_projectile.distance_traveled += movement.length()
		
		if _projectile.distance_traveled >= _projectile.range:
			_projectile.queue_free()
