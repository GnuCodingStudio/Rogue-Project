extends Control
class_name LobbyMenu

#Variables
@export var hostButton : Button
@export var joinButton : Button
@export var startButton : Button


const SERVER_PORT = 9999
const SERVER_IP = "localhost"

var enet_peer = ENetMultiplayerPeer.new()

func _create_server() -> void:
	print("host")
	enet_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	GlobalVariables.server_is_loaded = true
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")

func _join_server() -> void:
	enet_peer.create_client(SERVER_IP, SERVER_PORT)
	print(enet_peer)
	multiplayer.multiplayer_peer = enet_peer
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")
#
#
#func _on_player_name_edit_text_changed(new_text: String) -> void:
	#print("player name:", new_text)
	#player_name = new_text
#
#
#func _on_server_name_edit_text_changed(new_text: String) -> void:
	#print("server_ip:", new_text)
	#server_ip = new_text
