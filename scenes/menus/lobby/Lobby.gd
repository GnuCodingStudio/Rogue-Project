extends Control

#region connect-inputs
@onready var connect: Panel = $Connect
@onready var player_name_input: LineEdit = %PlayerNameInput
@onready var host_address_input: LineEdit = %HostAddressInput
@onready var host_button: Button = %Host
@onready var join_button: Button = %Join
@onready var error_label: Label = %ErrorLabel
#endregion connect-inputs

#region waiting-room
@onready var waiting_room: Panel = $WaitingRoom
@onready var players_list: ItemList = $WaitingRoom/PlayersList
@onready var play_button: Button = $WaitingRoom/Play
#endregion waiting-room

@onready var alert_dialog: AcceptDialog = $AlertDialog


func _ready() -> void:
	MultiplayerManager.connection_failed.connect(_on_connection_failed)
	MultiplayerManager.connection_succeeded.connect(_on_connection_success)
	MultiplayerManager.player_list_changed.connect(refresh_waiting_room)
	MultiplayerManager.game_error.connect(_on_game_error)

	#MacOS
	if OS.has_environment("USER"):
		player_name_input.text = OS.get_environment("USER")
	#Windows
	elif OS.has_environment("USERNAME"):
		player_name_input.text = OS.get_environment("USERNAME")
	else:
		player_name_input.text = "Pirate"

func _on_host_pressed() -> void:
	var player_name: String = player_name_input.text.strip_edges()
	if !_check_player_name(player_name): return

	connect.hide()
	waiting_room.show()
	error_label.text = ""

	MultiplayerManager.host_game(player_name)
	refresh_waiting_room()

func _on_join_pressed() -> void:
	var player_name: String = player_name_input.text.strip_edges()
	var host_address: String = host_address_input.text.strip_edges()
	if !_check_player_name(player_name): return
	if !_check_address(host_address):return

	error_label.text = ""
	host_button.disabled = true
	join_button.disabled = true
	play_button.visible = false

	MultiplayerManager.join_game(host_address, player_name)

func _check_player_name(name: String):
	if name.is_empty():
		error_label.text = "Invalid name!"
		return false
	else:
		return true

func _check_address(address: String):
	if address.is_empty():
		error_label.text = "Invalid address!"
		return false
	else:
		return true

func _on_play_pressed() -> void:
	waiting_room.hide()
	_load_map.rpc()
	#MultiplayerManager.begin_game()
	
@rpc("call_local")
func _load_map() -> void:
	SceneTransition.change_scene("res://scenes/map/Map.tscn")
	#MultiplayerManager.begin_game()

func _on_connection_success() -> void:
	connect.hide()
	waiting_room.show()

func _on_connection_failed() -> void:
	host_button.disabled = false
	join_button.disabled = false
	error_label.set_text("Connection failed.")

func _on_game_error(errtxt: String) -> void:
	alert_dialog.dialog_text = errtxt
	alert_dialog.popup_centered()
	host_button.disabled = false
	join_button.disabled = false

func refresh_waiting_room() -> void:
	var players := MultiplayerManager.get_player_name_list()

	players.sort()
	players_list.clear()
	players_list.add_item(MultiplayerManager.player_name + " (you)")
	for player: String in players:
		players_list.add_item(player)

	host_button.disabled = not multiplayer.is_server()
