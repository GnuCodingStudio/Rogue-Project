extends Control
class_name LobbyMenu

@onready var player_list: ItemList = $ItemList 
@onready var hostButton: Button = $HBoxContainer/Host 
@onready var joinButton : Button = $HBoxContainer/Join
@onready var startButton : Button = $StartGame

#Variables
var players_connected : Array = []
var player_name
var server_ip
var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	#peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	#server
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _create_server() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(GlobalVariables.SERVER_PORT)
	multiplayer.multiplayer_peer = enet_peer	
	add_player(multiplayer.get_unique_id(), player_name)
	_log_to_ui("Serveur créé sur le port %s " % GlobalVariables.SERVER_PORT)
	
func _join_server() -> void:
	enet_peer = ENetMultiplayerPeer.new()
	#Avoid en empty server_ip 
	if server_ip =="" or server_ip==null: 
		server_ip = "localhost"
	enet_peer.create_client(server_ip, GlobalVariables.SERVER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	_log_to_ui("Connexion au serveur %s" % server_ip)

func _start_the_game():
	StartGame.rpc()
	
@rpc("any_peer", "call_local")	
func StartGame():
	#Play the game
	_log_to_ui("Play the game ! ")
	
## Signals
func _on_peer_connected(id):
	if not multiplayer.is_server():
		return
	print("Joueur connecté avec ID : %s" % id)
	for i in range(0, PlayersManager.players.size()):
		rpc_id(id, "add_player", PlayersManager.players[i], get_player_name(i))
	rpc("add_player", id)
	
	if multiplayer.is_server():
		check_start_game()
		
func _on_peer_disconnected(id):
	print("Joueur déconnecté avec ID : %s" % id)
	if not multiplayer.is_server():
		return
	rpc("del_player", id)
	check_start_game()
	
func _on_connection_failed():
	_log_to_ui("Erreur de connexion")

func _on_connected_to_server():
	rpc("set_player_name", player_name)
	_log_to_ui("Connecté au serveur")
	
func _on_server_disconnected():
	_log_to_ui("Déconnecté du serveur")

## Playername function
@rpc("any_peer", "call_local")
func set_player_name(_name):
	var sender = multiplayer.get_remote_sender_id()
	rpc("update_player_name", sender, _name)
	
@rpc("any_peer", "call_local") 
func update_player_name(player, _name):
	var pos = PlayersManager.players.find(player)
	if pos != -1:
		player_list.set_item_text(pos, _name)
	
func get_player_name(pos):
	if pos < player_list.get_item_count():
		return player_list.get_item_text(pos)
	else:
		return "Error to retrieve player name!"
	
## Controls lobby
func check_start_game():
	if PlayersManager.players.size() > 1:
		startButton.disabled = false
		startButton.visible = true
	else:
		startButton.disabled = true
		startButton.visible = false
		
func check_player_name():
	if player_name != null and player_name != "":
		hostButton.disabled = false
		joinButton.disabled = false
	else:
		hostButton.disabled = true
		joinButton.disabled = true

## Manage list of players
@rpc("any_peer", "call_local") 
func add_player(id, _name=""):
	PlayersManager.players.append(id)
	if _name == "" or _name.is_empty():
		player_list.add_item("Player", null, false)
	else:
		player_list.add_item(_name, null, false)
		
@rpc("any_peer", "call_local") 
func del_player(id):
	var pos = PlayersManager.players.find(id)
	if pos == -1:
		return
	PlayersManager.players.remove_at(pos)
	player_list.remove_item(pos)

## Signals Edit field
func _on_player_name_edit_text_changed(new_text: String) -> void:
	player_name = new_text
	check_player_name()

func _on_server_name_edit_text_changed(new_text: String) -> void:
	server_ip = new_text

## Display
func _log_to_ui(message:String):
	var logs = $RichTextLabel
	logs.append_text("[color=white]%s[/color]\n" %message)
	logs.scroll_to_line(logs.get_line_count())
