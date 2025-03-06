class_name Projectile
extends Area2D

var range: float
var damage: float
var offset: float

var _targeted_direction: Vector2
var _distance_traveled: float = 0.0
var _speed: float = 400

func init(damage: int, range: float, direction: Vector2, offset: float):
	self.damage = damage
	self.range = range
	self._targeted_direction = direction
	self.offset = offset

func _ready() -> void:
	position += _targeted_direction * offset


func _on_body_entered(body: Node) -> void:
	if body is Mob:
		body.apply_attack(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	if _targeted_direction != Vector2.ZERO:
		var movement = _targeted_direction.normalized() * delta * _speed
		position += movement
		_distance_traveled += movement.length()
		
		if _distance_traveled >= range:
			queue_free()
