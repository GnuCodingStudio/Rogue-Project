class_name Follow extends State

@onready var _boss: Boss = owner
@onready var states: States = $".."
@onready var attack: State = $"../Attack"

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_boss.moving_direction = _boss.get_targeted_player().global_position - global_position

func transition() -> void:
	super.transition()
	var distance_to_player = _boss.global_position.distance_to(_boss.get_targeted_player().global_position)
	if distance_to_player < 100:
		states.change_state(attack)
