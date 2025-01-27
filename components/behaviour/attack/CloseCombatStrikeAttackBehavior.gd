class_name CloseCombatStrikeAttackBehavior
extends Area2D


@export var force: int = 10

@onready var attack_timer: Timer = %AttackTimer


var _mob: Mob


func _ready() -> void:
	assert(get_parent() is Mob)
	_mob = get_parent()


func _on_attack_timer_timeout() -> void:
	if _mob.targeted_players.is_empty(): return

	var attackable_players = get_overlapping_bodies().filter(func(b):return b is Player)
	for targeted_player in _mob.targeted_players:
		if targeted_player in attackable_players:
			targeted_player.apply_attack(force)
