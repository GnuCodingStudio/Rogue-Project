class_name Wave
extends Node


@export var start_time: int = 0
@export var spawn_interval: int = 0
@export_group("Mobs", "mobs_")
@export var mobs_min_count: int = 0
@export var mobs_max_count: int = 0
@export var mobs_scene: PackedScene


var _mobs_to_spawn: int
var _mobs_spawned: int = 0

var _spawn_points: Array[Node2D] = []


func _ready() -> void:
	_mobs_to_spawn = randi_range(mobs_min_count, mobs_max_count)
	for child in get_children():
		if child is Node2D:
			_spawn_points.push_back(child)


func spawn(parent: Node) -> bool:
	if _mobs_spawned >= _mobs_to_spawn:
		prints("Wave", name, "exhausted")
		return false

	prints("Spawning for wave", name, ", remaining:", _mobs_to_spawn - _mobs_spawned)
	for spawn_point in _spawn_points:
		prints("Spawning one for wave", name)
		var mob = _new_mob(spawn_point.global_position)
		prints("New mob", mob)
		parent.add_child(mob)
		prints("Parent children", parent.get_child_count())

	_mobs_spawned += _spawn_points.size()

	return true


func _new_mob(global_position: Vector2) -> Node2D:
	var mob: Mob = mobs_scene.instantiate()
	mob.global_position = global_position
	return mob
