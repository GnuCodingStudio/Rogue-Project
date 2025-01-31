extends Area2D
class_name Attack

var targeted_direction: Vector2
var distance_traveled: float = 0.0

var range: float
var damage: float
	
func init(_damage, _range, _direction):
	damage = _damage
	range = _range
	targeted_direction = _direction


func _on_body_entered(body: Node) -> void:
	if not body is Mob: return
	
	body.queue_free()
	queue_free()
