extends Control

@onready var player_name: LineEdit = $Connect/VBoxContainer2/HBoxContainer/UsernameInput
@onready var ip_server: LineEdit = $Connect/VBoxContainer2/HBoxContainer2/IPInput
@onready var start_button: Button = $Connect/VBoxContainer2/HBoxContainer/Host
@onready var join_button: Button = $Connect/VBoxContainer2/HBoxContainer2/Join
@onready var alert_dialog: AcceptDialog = $AlertDialog
@onready var players_list: ItemList = $WaitingRoom/PlayersList
@onready var play_button: Button = $WaitingRoom/Play
@onready var waiting_room: Panel = $WaitingRoom
@onready var connect: Panel = $Connect
@onready var error_label: Label = $Connect/VBoxContainer2/ErrorLabel

func _ready() -> void:
	Game.connection_failed.connect(_on_connection_failed)
	Game.connection_succeeded.connect(_on_connection_success)
	Game.player_list_changed.connect(refresh_lobby)
	Game.game_error.connect(_on_game_error)

	#MacOS
	if OS.has_environment("USER"):
		player_name.text = OS.get_environment("USER")
	#Windows
	elif OS.has_environment("USERNAME"):
		player_name.text = OS.get_environment("USERNAME")
	else:
		player_name.text = "Pirate"


func _on_host_pressed() -> void:
	if player_name.text == "":
		error_label.text = "Invalid name!"
		return

	connect.hide()
	waiting_room.show()
	error_label.text = ""

	Game.host_game(player_name.text)
	refresh_lobby()


func _on_join_pressed() -> void:
	
	if player_name.text == "":
		error_label.text = "Invalid name!"
		return

	var ip = ip_server.text
	
	if not ip.is_valid_ip_address():
		error_label.text = "Invalid IP address! Set IPv4 or IPv6 address"
		return

	error_label.text = ""
	start_button.disabled = true
	join_button.disabled = true
	play_button.visible = false

	var player_name: String = player_name.text
	Game.join_game(ip, player_name)


func _on_play_pressed() -> void:
	Game.begin_game()

func _on_connection_success() -> void:
	connect.hide()
	waiting_room.show()


func _on_connection_failed() -> void:
	start_button.disabled = false
	join_button.disabled = false
	error_label.set_text("Connection failed.")


func _on_game_error(errtxt: String) -> void:
	alert_dialog.dialog_text = errtxt
	alert_dialog.popup_centered()
	start_button.disabled = false
	join_button.disabled = false


func refresh_lobby() -> void:
	print("refresh")
	var players := Game.get_player_name_list()
	var players_ids := Game.get_player_name_ids_list()
	players.sort()
	players_list.clear()
	players_list.add_item(Game.player_name + " (you)")
	for player: String in players:
		players_list.add_item(player)

	start_button.disabled = not multiplayer.is_server()
