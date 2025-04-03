extends Control

@onready var name_field: LineEdit = %NameField
@onready var host_field: LineEdit = %HostField
@onready var port_field: LineEdit = %PortField
@onready var error_label: Label = %ErrorLabel
@onready var join_button: Button = %JoinButton

func _ready() -> void:
	MultiplayerManager.game_error.connect(_on_multiplayer_error)

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

func _on_name_changed(new_text: String) -> void:
	_check_form()

func _on_host_changed(new_text: String) -> void:
	_check_form()

func _on_port_changed(new_text: String) -> void:
	_check_form()

func _on_join_button_pressed() -> void:
	var player_name: String = name_field.text.strip_edges()
	var host_address: String = host_field.text.strip_edges()
	var port: int = port_field.text.to_int()
	_join_game(host_address, port, player_name)

func _join_game(host: String, port: int, player_name: String) -> void:
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_client(host, port)
	if result == OK:
		print("Server joined successfully %s:%d" % [host, port])
		multiplayer.set_multiplayer_peer(peer)
		SceneTransition.change_scene("res://scenes/menus/lobby/waiting/WaitingRoom.tscn")
	else:
		_on_multiplayer_error(result)

func _on_multiplayer_error(code: int) -> void:
	error_label.text = "Failed to create server. Error code: %d" % code
