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

var _spawn_points: Array[Marker2D] = []
var _spawn_node: Node

var _already_played: bool = false

func _ready() -> void:
	assert(mobs_scene != null, "Waves need a mob to spawn")

	timer.wait_time = spawn_interval
	_mobs_to_spawn = randi_range(mobs_min_count, mobs_max_count)
	for child in get_children():
		if child is Marker2D:
			_spawn_points.push_back(child)
		if child is Area2D:
			_setup_trigger_area(child)
	assert(_spawn_points.size() > 0, "Waves need at least one spawn point")

func init(parent: Node) -> void:
	_spawn_node = parent

func start() -> void:
	if not _already_played:
		_already_played = true
		_spawn()
		timer.start()

func _setup_trigger_area(area: Area2D) -> void:
	if area:
		area.body_entered.connect(_on_trigger_entered)

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

#region signal

func _on_spawn_timeout() -> void:
	_spawn()

func _on_trigger_entered(body: RigidBody2D) -> void:
	start()

#endregion signal
