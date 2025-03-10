class_name Boss extends Mob

@export var players_node: Node

var players: Array[Player] = []

func _ready() -> void:
	for node in players_node.get_children():
		if node is Player:
			players.push_back(node)
	prints("Boss found players:", players)
