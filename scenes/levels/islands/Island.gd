extends Node2D

func _on_leave_level():
	SceneTransition.change_scene("res://scenes/map/Map.tscn")
	
#func _ready() -> void:
	#_add_players()
	#
#func _add_players():
	#var spawn_points := {}
	#var spawn_point_index = 1
	#var player_scene: PackedScene = preload("res://objects/actors/player/Player.tscn")
	 #
	## Create a dictionary with peer ID link to spawn points.
	## Host id = 1 and spawn point is 0
	#spawn_points[1] = 0
	## Client id stock in players variable
	## TODO: Need to choose the number of players can we have on the game
	#for p in MultiplayerManager.players:
		#spawn_points[p] = spawn_point_index
		#spawn_point_index += 1
		#
	#for player_id in spawn_points:
		##prints("spawn point =", str(spawn_points[player_id]))
		#var spawn_position: Vector2 = $"SpawnPoint/0".position
		##prints("spawn_position =", spawn_position)
		#var player = player_scene.instantiate()
		#player.name = str(player_id)
		#$Players.add_child(player, true)
		#var player_name
		#if player_id != multiplayer.get_unique_id():
			#player_name = MultiplayerManager.players[player_id]
		#
		#player.set_player_name.rpc(player_name)
		#player.set_player_position.rpc(spawn_position)
