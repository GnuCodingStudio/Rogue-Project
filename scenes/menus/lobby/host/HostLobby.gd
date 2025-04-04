extends Control

@onready var crew_name_field: LineEdit = %CrewNameField
@onready var captain_name_field: LineEdit = %CaptainNameField
@onready var port_field: LineEdit = %PortField
@onready var error_label: Label = %ErrorLabel
@onready var start_button: Button = %StartButton

const MAX_PEERS = 4

func _ready() -> void:
	crew_name_field.text = MultiplayerManager.get_default_player_name()
	captain_name_field.text = MultiplayerManager.get_default_player_name()

#region signal

func _on_port_text_changed(new_text: String) -> void:
	_check_form()

func _on_capitain_name_text_changed(new_text: String) -> void:
	_check_form()

func _on_crew_name_text_changed(new_text: String) -> void:
	_check_form()

func _on_start_button_pressed() -> void:
	var captain_name = captain_name_field.text
	var port = port_field.text.to_int()
	_host_game(captain_name, port)

func _on_back_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/menus/main/MainMenu.tscn")

#endregion signal

#region private

func _host_game(player_name: String, port: int) -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(port, MAX_PEERS)
	if result == OK:
		print("Server created successfully on port %d" % port)
		multiplayer.multiplayer_peer = peer
		MultiplayerManager.register_me(player_name)
		SceneTransition.change_scene("res://scenes/menus/lobby/waiting/WaitingRoom.tscn")
	else:
		_show_error(result)

func _check_form() -> void:
	var valid = true
	
	if captain_name_field.text.is_empty():
		valid = false
	if not port_field.text.is_valid_int():
		valid = false
	
	var port = port_field.text.to_int()
	if port < 1 or port > 65535:
		valid = false
	
	start_button.disabled = not valid

func _show_error(code: int) -> void:
	error_label.text = "Failed to create server. Error code: %d" % code

#endregion private
