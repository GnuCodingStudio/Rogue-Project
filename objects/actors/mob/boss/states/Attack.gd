class_name Attack extends State

@onready var _boss: Boss = owner
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite

@onready var states: States = $".."
@onready var follow: Follow = $"../Follow"
@onready var idle: Idle = $"../Idle"
@onready var spawn_mob: SpawnMob = $"../SpawnMob"

var _is_attacking := false

func enter() -> void:
	super.enter()
	_is_attacking = true
	attack()

func exit() -> void:
	super.exit()
	_is_attacking = false

func attack() -> void:
	var direction = _boss._direction_name()
	animated_sprite.play("Attack" + direction)
	await animated_sprite.animation_finished
	if _is_attacking:
		attack()

func transition() -> void:
	super.transition()
	var player = _boss.get_targeted_player()
	if not player:
		states.change_state(idle)
		return

	var distance_to_player = _boss.global_position.distance_to(player.global_position)
	if distance_to_player > 80:
		if randi() % 10 < 3:
			states.change_state(spawn_mob)
		else:
			states.change_state(follow)
