class_name Attack extends State

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var _boss: Boss = owner
@onready var states: States = $".."
@onready var follow: Follow = $"../Follow"
@onready var idle: Idle = $"../Idle"

func enter() -> void:
	super.enter()
	attack()

func attack() -> void:
	var direction = _boss._direction_name()
	var attack_animation = "Attack" + direction
	prints("attack_animation", attack_animation)
	animated_sprite.play(attack_animation)
	await animated_sprite.animation_finished
	attack()

func transition() -> void:
	super.transition()
	var player = _boss.get_targeted_player()
	if not player:
		states.change_state(idle)
		return
	
	var distance_to_player = _boss.global_position.distance_to(player.global_position)
	if distance_to_player > 80:
		states.change_state(follow)
