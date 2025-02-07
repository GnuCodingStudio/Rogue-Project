extends Control

@onready var player_name: LineEdit = $Connect/VBoxContainer2/HBoxContainer/UsernameInput
@onready var ip_server: LineEdit = $Connect/VBoxContainer2/HBoxContainer2/IPInput
@onready var host_button: Button = $Connect/VBoxContainer2/HBoxContainer/Host
@onready var join_button: Button = $Connect/VBoxContainer2/HBoxContainer2/Join
@onready var alert_dialog: AcceptDialog = $AlertDialog
@onready var players_list: ItemList = $WaitingRoom/PlayersList
@onready var play_button: Button = $WaitingRoom/Play
@onready var waiting_room: Panel = $WaitingRoom
@onready var connect: Panel = $Connect
@onready var error_label: Label = $Connect/VBoxContainer2/ErrorLabel


func _ready() -> void:
	MultiplayerManager.connection_failed.connect(_on_connection_failed)
	MultiplayerManager.connection_succeeded.connect(_on_connection_success)
	MultiplayerManager.player_list_changed.connect(refresh_lobby)
	MultiplayerManager.game_error.connect(_on_game_error)

	#MacOS
	if OS.has_environment("USER"):
		player_name.text = OS.get_environment("USER")
	#Windows
	elif OS.has_environment("USERNAME"):
		player_name.text = OS.get_environment("USERNAME")
	else:
		player_name.text = "Pirate"


func _on_host_pressed() -> void:		
	if !_check_player_name(): return

	connect.hide()
	waiting_room.show()
	error_label.text = ""

	MultiplayerManager.host_game(player_name.text)
	refresh_lobby()


func _on_join_pressed() -> void:
	if !_check_player_name(): return
	if !_check_ip():return

	error_label.text = ""
	host_button.disabled = true
	join_button.disabled = true
	play_button.visible = false

	var player_name: String = player_name.text
	var ip: String = ip_server.text
	MultiplayerManager.join_game(ip, player_name)


func _check_player_name():
	if player_name.text == "":
		error_label.text = "Invalid name!"
		return false
	else:
		return true
		
func _check_ip():
	if not ip_server.text.is_valid_ip_address():
		error_label.text = "Invalid IP address! Set IPv4 or IPv6 address"
		return false
	else:
		return true

func _on_play_pressed() -> void:
	MultiplayerManager.begin_game()


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


func refresh_lobby() -> void:
	var players := MultiplayerManager.get_player_name_list()

	players.sort()
	players_list.clear()
	players_list.add_item(MultiplayerManager.player_name + " (you)")
	for player: String in players:
		players_list.add_item(player)

	host_button.disabled = not multiplayer.is_server()
