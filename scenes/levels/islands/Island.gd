class_name Island
extends Node2D

@onready var deathScreen = %DeathScreen
@onready var chest: Chest = %Chest

func _on_player_dead(player: Player):
	if (player.hasChest): _chest_drop(player)
	await deathScreen.start_timer()
	player.respawn()

func _on_leave_level():
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

func _chest_drop(player: Player):
	chest.drop(player.global_position)
	player.hasChest = false

func _on_multiplayer_spawner_spawned(node):
	if node is Player and node.name == str(multiplayer.get_unique_id()):
		node.on_player_dead.connect(_on_player_dead)
