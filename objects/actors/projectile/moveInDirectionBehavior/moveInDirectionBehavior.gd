extends Node

var _projectile: Projectile

func _ready() -> void:
	assert(get_parent() is Projectile)
	_projectile = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _projectile.targeted_direction != Vector2.ZERO:
		_projectile.moving_direction = _projectile.targeted_direction.normalized()
		
		_projectile.distance_traveled += _projectile.moving_direction.length()
		
		if _projectile.distance_traveled >= _projectile.max_range:
			_projectile.queue_free()
