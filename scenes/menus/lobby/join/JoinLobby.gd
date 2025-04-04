extends Control

@onready var name_field: LineEdit = %NameField
@onready var host_field: LineEdit = %HostField
@onready var port_field: LineEdit = %PortField
@onready var error_label: Label = %ErrorLabel
@onready var join_button: Button = %JoinButton

#region signal

func _on_name_changed(new_text: String) -> void:
	_check_form()

func _on_host_changed(new_text: String) -> void:
	_check_form()

func _on_port_changed(new_text: String) -> void:
	_check_form()

func _on_join_button_pressed() -> void:
	_enable_form(false)
	var player_name: String = name_field.text.strip_edges()
	var host_address: String = host_field.text.strip_edges()
	var port: int = port_field.text.to_int()
	_join_game(host_address, port, player_name)

func _on_connected_to_server() -> void:
	SceneTransition.change_scene("res://scenes/menus/lobby/waiting/WaitingRoom.tscn")

func _connection_failed() -> void:
	_show_error(-1000)
	_enable_form(true)

func _on_back_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/menus/main/MainMenu.tscn")

#endregion signal

#region private

func _check_form() -> void:
	var valid = true
	
	if name_field.text.is_empty():
		valid = false
	if host_field.text.is_empty():
		valid = false
	if not port_field.text.is_valid_int():
		valid = false
	
	var port = port_field.text.to_int()
	if port < 1 or port > 65535:
		valid = false
	
	join_button.disabled = not valid
	
func _join_game(host: String, port: int, player_name: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(host, port)
	if result == OK:
		print("Server joined successfully %s:%d" % [host, port])
		multiplayer.multiplayer_peer = peer
		multiplayer.connected_to_server.connect(_on_connected_to_server)
		multiplayer.connection_failed.connect(_connection_failed)
	else:
		_show_error(result)
		_enable_form(true)

func _enable_form(enabled: bool) -> void:
	join_button.disabled = not enabled
	name_field.editable = enabled
	host_field.editable = enabled
	port_field.editable = enabled

func _show_error(code: int) -> void:
	error_label.text = "Failed to join crew, code: %d" % code

#endregion private
