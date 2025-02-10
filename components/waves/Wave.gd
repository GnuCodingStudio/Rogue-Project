class_name Wave
extends Node

@export var start_time: int = 0
@export var spawn_interval: int = 0
@export_group("Mobs", "mobs_")
@export var mobs_min_count: int = 0
@export var mobs_max_count: int = 0
@export var mobs_scene: PackedScene

@onready var timer: Timer = $Timer

var _mobs_to_spawn: int
var _mobs_spawned: int = 0

var _spawn_points: Array[Node2D] = []
var _spawn_node: Node

var _already_played: bool = false

func _ready() -> void:
	timer.wait_time = spawn_interval
	_mobs_to_spawn = randi_range(mobs_min_count, mobs_max_count)
	for child in get_children():
		if child is Node2D:
			_spawn_points.push_back(child)

func start(parent: Node) -> void:
	if timer.is_stopped() and not _already_played:
		_already_played = true
		_spawn_node = parent
		_spawn()
		timer.start()

func _spawn() -> void:
	var wave_finished = _mobs_spawned >= _mobs_to_spawn
	if wave_finished:
		timer.stop()
		return

	print("Spawning for wave ", name, ". Remaining: ", _mobs_to_spawn - _mobs_spawned)
	for spawn_point in _spawn_points:
		var mob = _spawn_mob_at(spawn_point.global_position)
		_spawn_node.add_child(mob)
		_mobs_spawned += 1

func _spawn_mob_at(global_position: Vector2) -> Node2D:
	var mob: Mob = mobs_scene.instantiate()
	mob.global_position = global_position
	return mob

func _on_spawn_timeout() -> void:
	_spawn()
