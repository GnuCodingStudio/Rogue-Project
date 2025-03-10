class_name Follow extends State

@onready var _boss: Boss = owner
@onready var states: States = $".."
@onready var attack: State = $"../Attack"

func _process(delta: float) -> void:
	_boss.moving_direction = _get_player_to_follow().global_position - global_position

func transition() -> void:
	super.transition()
	var distance_to_player = _boss.global_position.distance_to(_get_player_to_follow().global_position)
	if distance_to_player < 100:
		states.change_state(attack)

func _get_player_to_follow() -> Player:
	if _boss.players == null: return null
	if _boss.players.is_empty(): return null

	var players = _boss.players
	players.sort_custom(_sort_by_distance)
	return players[0]

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var distance_to_a = a.global_position.distance_to(self.global_position)
	var distance_to_b = b.global_position.distance_to(self.global_position)
	return (distance_to_a < distance_to_b)
