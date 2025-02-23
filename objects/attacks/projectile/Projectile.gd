class_name Projectile
extends Area2D

var range: float
var damage: float
var offset: float

var _targeted_direction: Vector2
var _distance_traveled: float = 0.0
var _speed: float = 400
	
func init(_damage: int, _range, _direction, _offset):
	damage = _damage
	range = _range
	_targeted_direction = _direction
	offset = _offset

func _ready() -> void:
	position = position + _targeted_direction * offset


func _on_body_entered(body: Node) -> void:
	if body is Mob:
		body.queue_free()
		queue_free()


func _physics_process(delta: float) -> void:
	if _targeted_direction != Vector2.ZERO:
		var movement = _targeted_direction.normalized() * delta * _speed
		position += movement
		_distance_traveled += movement.length()
		
		if _distance_traveled >= range:
			queue_free()
