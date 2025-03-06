class_name Boss extends Mob

@export var players_node: Node

@onready var states: States = $States
@onready var follow: Follow = $States/Follow

var players: Array[Player] = []

func _ready() -> void:
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
