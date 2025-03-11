class_name Melee
extends Node2D

var range: float
var damage: float

var _targeted_direction: Vector2 = Vector2(0,0)
var _radius: float = 0
var _animation_duration: float = .2

@onready var attack: Area2D = %Sword
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

func init(damage: int, range: float, direction: Vector2, offset: float):
	self.damage = damage
	self.range = range
	self._targeted_direction = direction
	self._radius = offset

func _ready() -> void:
	attack.position += Vector2.RIGHT * _radius
	_start_tween()

func _start_tween():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	var phi = _targeted_direction.angle()
	var start_rotation = phi + deg_to_rad(-range/2)
	var end_rotation = phi + deg_to_rad(range/2)

	self.rotation = start_rotation

	tween.tween_property(
		self,
		"rotation",
		end_rotation,
		_animation_duration
	)

	tween.tween_callback(queue_free)

func _on_sword_body_entered(body: Node2D) -> void:
	if body is Mob:
		body.receive_damage(damage)
