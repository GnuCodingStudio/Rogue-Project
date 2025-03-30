extends Node

# Maybe we can export theses constants to a global variables project ?
const DEFAULT_PORT = 28000
const MAX_PEERS = 4

var peer: ENetMultiplayerPeer
var player_name := "Pirate"

## Names for remote players in id:name format.
var players: Dictionary = {}
var spawn_point_index = 1
var spawn_points: Dictionary = {1: 0} # Host ID = 1, spawn point = 0

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
	game_error.emit("Player " + get_player(id).pseudo + " disconnected")
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
	players[id] = PlayerData.new(id, new_player_name)
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

func get_players() -> Array[PlayerData]:
	var x : Array[PlayerData] = []
	for p in players.values():
		if p is PlayerData:
			x.push_back(p)
	return x

func get_player(id: int) -> PlayerData:
	if players.has(id): return players[id]
	else: return null

func weapon_are_selected() -> bool:
	for player in players.values():
		if player.weapon < 0:
			return false
	return true

@rpc("call_local", "reliable")
func _load_island():
	var island_scene: Node2D = load("res://scenes/levels/islands/Island.tscn").instantiate()
	get_tree().get_root().add_child(island_scene)

func begin_game():
	_load_island.rpc()
	_add_player_and_spawn_position()

func _add_player_and_spawn_position(): 
	_assign_spawn_point_to_players()
	_spawn_players()

func _assign_spawn_point_to_players():
	for player_id in players:
		spawn_points[player_id] = spawn_point_index
		spawn_point_index += 1

func _spawn_players():
	var player_scene: PackedScene = preload("res://objects/actors/player/Player.tscn")
	var island: Island = get_tree().get_root().get_node("Island")

	for player_id in spawn_points:
		var spawn_position: Vector2 = island.get_node("SpawnPoint/" + str(spawn_points[player_id])).position
		var player: Player = player_scene.instantiate()
		player.name = str(player_id)
		island.get_node("Players").add_child(player, true)
		
		var player_data = get_player(player_id)
		if player_data:
			player.set_player_name.rpc(player_data.pseudo)
		else:
			player.set_player_name.rpc(player_name)
		player.set_player_position.rpc(spawn_position)
		
		if player_id == 1:
			player.on_player_dead.connect(island._on_player_dead)
