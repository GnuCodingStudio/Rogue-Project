class_name CloseCombatStrikeAttackBehavior
extends Area2D


@export var force: int = 10
@export var attack_animation: AnimatedSprite2D

@onready var attack_timer: Timer = %AttackTimer


var _mob: Mob


func _ready() -> void:
	assert(get_parent() is Mob)
	_mob = get_parent()


func _on_attack_timer_timeout() -> void:
	if not _mob.targeted_players.is_empty():
		_attack()


func _attack() -> void:
	var has_attacked := false
	var attackable_players = get_overlapping_bodies().filter(func(b):return b is Player)
	for targeted_player in _mob.targeted_players:
		if targeted_player in attackable_players:
			targeted_player.apply_attack(force)
			has_attacked = true

	if has_attacked:
		_play_attack_animation()


func _play_attack_animation() -> void:
	if attack_animation:
		attack_animation.global_rotation = attack_animation.global_position.angle_to_point(_mob.targeted_players[0].global_position)
		attack_animation.play("attack")
