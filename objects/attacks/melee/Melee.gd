class_name Melee
extends Node2D

var range: float
var damage: float

var _targeted_direction: Vector2 = Vector2(0,0)
var _radius: float = 0
var _phi: float = 0
var _attack_points_count: float = 30;
var _attack_points: PackedVector2Array = PackedVector2Array()
var _attack_points_angles: PackedFloat32Array = PackedFloat32Array()
var _animation_duration: float = 0.25

@onready var _attack: Area2D = %Sword
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

@export var DEBUG_MODE = false
	
func init(_damage: int, _range, _direction, _offset):
	damage = _damage
	range = _range
	_targeted_direction = _direction
	_radius = _offset

func _ready() -> void:
	_phi = _targeted_direction.angle()
	
	for i in range(_attack_points_count + 1):
		var angle = _phi + deg_to_rad(-range/2 + (range * i / _attack_points_count))
		var point = position + Vector2(cos(angle), sin(angle)) * _radius
		_attack_points_angles.append(angle + PI/2)
		_attack_points.append(point)
		
	_attack.position = _attack_points[0]
	_attack.rotation = _attack_points_angles[0]
	
	_start_tween()

func _start_tween():
	var tween = create_tween()
	
	var point_duration = _animation_duration / _attack_points.size()
	
	for i in range(_attack_points_count):
		tween.tween_property(
			_attack,
			"position",
			_attack_points[i],
			point_duration
		).set_trans(Tween.TRANS_CUBIC)
		
		tween.parallel().tween_property(
			_attack,
			"rotation",
			_attack_points_angles[i],
			point_duration
		).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(queue_free)

func _draw() -> void:
	if(!DEBUG_MODE): return
	
	draw_circle(position, _radius, Color(0, 0, 1), false, 2.0)
	draw_line(position, _targeted_direction * 100, Color(1, 0, 0), 2.0)
	
	for i in range(_attack_points_count):
		draw_line(_attack_points[i], _attack_points[i+1], Color(0,1,1), 2)


func _on_melee_body_entered(body: Node2D) -> void:
	if body is Mob:
		body.queue_free()
