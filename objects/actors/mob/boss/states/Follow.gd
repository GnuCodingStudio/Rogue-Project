class_name Follow extends State

@onready var _boss: Boss = owner
@onready var states: States = $".."
@onready var attack: State = $"../Attack"
@onready var idle: Idle = $"../Idle"

var _following : bool = false

func enter() -> void:
	super.enter()
	_following = true

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var player = _boss.get_targeted_player()
	if not player:
		states.change_state(idle)
		return

	if _following:
		_boss.moving_direction = player.global_position - global_position

func transition() -> void:
	super.transition()
	var player = _boss.get_targeted_player()
	if not player:
		states.change_state(idle)
		return
		
	var distance_to_player = _boss.global_position.distance_to(player.global_position)
	if distance_to_player < 60:
		_following = false
		_boss.moving_direction = Vector2.ZERO
		states.change_state(attack)
