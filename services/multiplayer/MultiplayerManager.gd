extends Node

# Maybe we can export theses constants to a global variables project ?
const DEFAULT_PORT = 28000
const MAX_PEERS = 4

var peer: ENetMultiplayerPeer
var player_name := "Pirate"

## Names for remote players in id:name format.
var players := {}
var spawn_points := {}
var spawn_point_index = 1

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_error(error: int)


func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)


func _peer_connected(id: int) -> void:
	register_player.rpc_id(id, player_name)


func _peer_disconnected(id: int) -> void:
	game_error.emit("Player " + players[id] + " disconnected")
	unregister_player(id)


#region Client only
func _connected_to_server() -> void:
	connection_succeeded.emit()


func _server_disconnected() -> void:
	game_error.emit("Server disconnected")


func _connection_failed() -> void:
	multiplayer.set_network_peer(null) # Remove peer
	game_error.emit("Failed connection")
	connection_failed.emit()
#endregion Client only


#region Lobby management functions.
@rpc("any_peer")
func register_player(new_player_name: String) -> void:
	var id := multiplayer.get_remote_sender_id()
	players[id] = new_player_name
	player_list_changed.emit()


func unregister_player(id: int) -> void:
	players.erase(id)
	player_list_changed.emit()


func host_game(new_player_name: String) -> void:
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(DEFAULT_PORT, MAX_PEERS)
	if result == OK:
		multiplayer.set_multiplayer_peer(peer)
		print("Server created successfully on port %d" % DEFAULT_PORT)
	else:
		game_error.emit("Failed to create server. Error code: %d" % result)

func join_game(ip: String, new_player_name: String) -> void:
	player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(ip, DEFAULT_PORT)
	if result == OK:
		multiplayer.set_multiplayer_peer(peer)
		print("Server joined successfully on ip %s" % ip)
	else:
		game_error.emit("Failed to join server. Error code: %d" % result)
#endregion Lobby management functions.


func get_player_name_list() -> Array:
	return players.values()
	

@rpc("any_peer", "call_local")
func load_island() -> void:
	prints("load_island", multiplayer.get_unique_id())

	# Change scene.
	var island: Node2D = load("res://scenes/levels/islands/Island.tscn").instantiate()
	get_tree().get_root().add_child(island)
	#get_tree().get_root().get_node("Lobby").hide()
	
	#SceneTransition.change_scene("res://scenes/levels/islands/Island.tscn")

	
func begin_game():
	#assert(multiplayer.is_server())
	if not is_multiplayer_authority(): return

	prints("begin game", multiplayer.get_unique_id())
	load_island.rpc()
	
	var island: Node2D = get_tree().get_root().get_node("Island")
	var player_scene: PackedScene = preload("res://objects/actors/player/Player.tscn")
	 
	# Create a dictionary with peer ID link to spawn points.
	# Host id = 1 and spawn point is 0
	spawn_points[1] = 0
	# Client id stock in players variable
	# TODO: Need to choose the number of players can we have on the game
	for p in players:
		spawn_points[p] = spawn_point_index
		spawn_point_index += 1
		
	for player_id in spawn_points:
		prints("spawn point =", str(spawn_points[player_id]))
		var spawn_position: Vector2 = island.get_node("SpawnPoint/" + str(spawn_points[player_id])).position
		#var spawn_position: Vector2 = island.get_node("SpawnPoint/0").position
		prints("spawn_position =", spawn_position)
		var player = player_scene.instantiate()
		player.name = str(player_id)
		island.get_node("Players").add_child(player, true)
		
		if player_id != multiplayer.get_unique_id():
			player_name = players[player_id]
		
		player.set_player_name.rpc(player_name)
		player.set_player_position.rpc(spawn_position)
