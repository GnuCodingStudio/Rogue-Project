extends Node2D

@onready var deathScreen = %DeathScreen
@onready var player = $Player
@onready var chest = %Chest

func _on_player_dead(player: Player):
	if (player.hasChest): _chest_drop()
	await deathScreen.start_timer()
	player.respawn()
	
func _on_leave_level():
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

func _chest_drop():
	chest.drop(player.position)
	player.hasChest = false
