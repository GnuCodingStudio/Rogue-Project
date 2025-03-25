class_name Boss extends Mob

@export var players_node: Node

@onready var states: States = $States
@onready var follow: Follow = $States/Follow
@onready var death: Death = $States/Death

@onready var health_bar: HealthBar = %HealthBar

var players: Array[Player] = []

func _ready():
	health_bar.init(_currentHealth)
	for node in players_node.get_children():
		if node is Player:
			players.push_back(node)
	prints("Boss found players:", players)

func get_targeted_player() -> Player:
	if players == null: return null
	if players.is_empty(): return null

	players.sort_custom(_sort_by_distance)
	return players[0]

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var distance_to_a = a.global_position.distance_to(self.global_position)
	var distance_to_b = b.global_position.distance_to(self.global_position)
	return (distance_to_a < distance_to_b)

func _update_animation() -> void:
	if states.current_state == follow:
		super._update_animation()

func _on_hit():
	super._on_hit()
	health_bar.value = _currentHealth

func _on_death() -> void:
	super._on_death()
	states.change_state(death)
