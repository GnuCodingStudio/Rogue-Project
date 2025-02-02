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
		if moving_direction != value:
			moving_direction = value
			_on_moving_direction_changed()

var facing_direction := Vector2.DOWN:
	set(value):
		if facing_direction != value:
			facing_direction = value
			_on_facing_direction_changed()


enum State {
	IDLE,
	MOVING
}

func _ready3() -> void:
	var i := 0
	while i < 360:
		var vec = Vector2.from_angle(deg_to_rad(i))
		prints("round 8", i, _roundv(vec, 8))
		i+=2
	prints("---------------------")

func _ready2() -> void:
	prints("UP", _roundv(Vector2.UP, 8))
	prints("RIGHT", _roundv(Vector2.RIGHT, 8))
	prints("DOWN", _roundv(Vector2.DOWN, 8))
	prints("LEFT", _roundv(Vector2.LEFT, 8))
	prints("UP-LEFT", _roundv(Vector2(-.8,-.8), 8))
	prints("UP-RIGHT", _roundv(Vector2(.8,-.8), 8))
	prints("DOWN-LEFT", _roundv(Vector2(-.8,.8), 8))
	prints("DOWN-RIGHT", _roundv(Vector2(.8,.8), 8))
	prints("UP-UP-LEFT", _roundv(Vector2(-.5,-.86), 8))
	prints("UP-UP-RIGHT", _roundv(Vector2(.5,-.86), 8))
	prints("ALMOST-UP", _roundv(Vector2(-0.1,-.9), 8))
	prints("ALMOST-UP", _roundv(Vector2(0.1,-.9), 8))
	prints("-0 == 0", -0 == 0)
	prints("-0 == 0 (VECTOR)", Vector2.UP == Vector2(-0, -1))
	prints("---------------------")


func _process(delta):
	$FacingDebug.position = facing_direction * 50
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

func _are_close(vec1: Vector2, vec2: Vector2) -> bool:
	return abs(vec1.angle_to(vec2)) < 0.0001

func _update_animation():
	var state_name := ""
	match state:
		State.IDLE: state_name = "Idle"
		State.MOVING: state_name = "Move"

	var animation_name = state_name + _direction_name()
	if self is Mob:
		prints("update animation", animation_name)
	animated_sprite.play(animation_name)


func _on_state_changed():
	_update_animation()

func _on_moving_direction_changed():
	var moving_direction = _roundv(moving_direction, 8)
	if self is Mob:
		prints("rounded moving_direction", moving_direction, "facing", facing_direction)
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return

	if facing_direction.x == sign(moving_direction.x):
		facing_direction = Vector2(0, sign(moving_direction.y))
	elif facing_direction.y == sign(moving_direction.y):
		facing_direction = Vector2(sign(moving_direction.x), 0)
	else:
		facing_direction = moving_direction


func _on_moving_direction_changed_0():
	if moving_direction == Vector2.ZERO or moving_direction == facing_direction:
		return

	if facing_direction.x == sign(moving_direction.x):
		facing_direction = Vector2(0, sign(moving_direction.y))
	elif facing_direction.y == sign(moving_direction.y):
		facing_direction = Vector2(sign(moving_direction.x), 0)
	else:
		facing_direction = moving_direction


func _on_moving_direction_changed_1():
	var rounded_moving_direction = _roundv(moving_direction.normalized(), 8)
	if self is Mob:
		prints("moving direction changed", rounded_moving_direction, facing_direction)
	if moving_direction == Vector2.ZERO or rounded_moving_direction == facing_direction:
		if self is Mob:
			prints("same direction")
		return
	if self is Mob:
		prints("NOT same direction")

	if facing_direction.x == sign(rounded_moving_direction.x):
		facing_direction = Vector2(0, sign(rounded_moving_direction.y))
	elif facing_direction.y == sign(rounded_moving_direction.y):
		facing_direction = Vector2(sign(rounded_moving_direction.x), 0)
	else:
		facing_direction = rounded_moving_direction.normalized()

	if self is Mob:
		prints("new facing", facing_direction)


func _on_facing_direction_changed():
	if self is Mob:
		prints("facing", facing_direction)
	_update_animation()


func _roundv(vector: Vector2, directions: int) -> Vector2:
	var scale = (2 * PI) / directions
	var rounded_angle: float = roundf(vector.angle() / scale) * scale
	return Vector2.from_angle(rounded_angle)
