extends RigidBody2D
class_name Actor

@export var speed = 300.0

@onready var animated_sprite = %AnimatedSprite
@onready var collision_shape = %CollisionShape


var state := State.IDLE:
	set(value):
		if state != value:
			state = value
			_on_state_changed()

var moving_direction := Vector2.ZERO:
	set(value):
		var rounded_value = _roundv(value, 8)
		if not _are_close(moving_direction, rounded_value):
			moving_direction = rounded_value
			_on_moving_direction_changed()

var facing_direction := Vector2.DOWN:
	set(value):
		if not _are_close(facing_direction, value):
			facing_direction = value
			_on_facing_direction_changed()


enum State {
	IDLE,
	MOVING
}


func _process(delta):
	if moving_direction == Vector2.ZERO:
		state = State.IDLE
	else:
		state = State.MOVING


func _physics_process(delta):
	move_and_collide(moving_direction.normalized() * speed * delta)


func _direction_name() -> String:
	if (_are_close(facing_direction, Vector2.UP)): return "Up"
	elif (_are_close(facing_direction, Vector2.DOWN)): return "Down"
	elif (_are_close(facing_direction, Vector2.LEFT)): return "Left"
	elif (_are_close(facing_direction, Vector2.RIGHT)): return "Right"
	else: return "Down"


func _update_animation():
	var state_name := ""
	match state:
		State.IDLE: state_name = "Idle"
		State.MOVING: state_name = "Move"

	var animation_name = state_name + _direction_name()
	animated_sprite.play(animation_name)


func _on_state_changed():
	_update_animation()


func _on_moving_direction_changed():
	if moving_direction == Vector2.ZERO or _are_close(moving_direction, facing_direction):
		return

	if facing_direction.x == sign(moving_direction.x):
		facing_direction = Vector2(0, sign(moving_direction.y))
	elif facing_direction.y == sign(moving_direction.y):
		facing_direction = Vector2(sign(moving_direction.x), 0)
	else:
		facing_direction = moving_direction


func _on_facing_direction_changed():
	_update_animation()


func _are_close(vec1: Vector2, vec2: Vector2) -> bool:
	return abs(vec1.angle_to(vec2)) < 0.0001 && abs(vec1.length() - vec2.length()) < 0.0001


func _roundv(vector: Vector2, directions: int) -> Vector2:
	if vector == Vector2.ZERO:
		return Vector2.ZERO

	var scale = (2 * PI) / directions
	var rounded_angle: float = roundf(vector.angle() / scale) * scale
	return Vector2.from_angle(rounded_angle)
