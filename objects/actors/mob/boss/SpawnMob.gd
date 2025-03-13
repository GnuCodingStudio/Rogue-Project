class_name SpawnMob extends State

@onready var states: States = $".."
@onready var follow: Follow = $"../Follow"
@onready var minions: Node2D = %Minions
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite

@export var mob_scene: PackedScene = preload("res://objects/actors/mob/dummy/DummyMob.tscn")
@export var mob_min: int = 2
@export var mob_max: int = 6

var _has_spawned_mobs: bool = false

func enter() -> void:
	_has_spawned_mobs = false
	super.enter()
	animated_sprite.play("IdleDown")
	await get_tree().create_timer(1).timeout
	await _spawn_mobs()
	_has_spawned_mobs = true

func transition() -> void:
	if _has_spawned_mobs:
		states.change_state(follow)

func _spawn_mobs() -> void:
	for i in _random_mobs_count():
		_spawn_mob_at(_random_spawn_point())
		await get_tree().create_timer(.6).timeout

func _random_mobs_count() -> int:
	return randi_range(mob_min, mob_max)

func _random_spawn_point() -> Node2D:
	return minions.get_children()[randi() % minions.get_child_count()]

func _spawn_mob_at(node: Node2D):
	var mob = mob_scene.instantiate() as Mob
	get_parent().add_child(mob)
	mob.global_position = node.global_position
