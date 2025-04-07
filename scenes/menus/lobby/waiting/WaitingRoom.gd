extends Control

@onready var play_button: Button = %StartButton
@onready var players: GridContainer = %Players

var _ready_players: Array[int] = []

const WAITING_PLAYER_PANEL = preload("res://scenes/menus/lobby/waiting/WaitingPlayerPanel.tscn")

func _ready() -> void:
	if multiplayer.is_server():
		play_button.text = "WAITING_START_BUTTON"
	else:
		play_button.text = "WAITING_READY_BUTTON"
		play_button.toggle_mode = true
	MultiplayerManager.player_list_changed.connect(_on_players_changed)
	_on_players_changed()

func _on_players_changed() -> void:
	var all_players_ready := true
	for c in players.get_children(): c.queue_free()
	
	var players_list = MultiplayerManager.get_players()
	for player in players_list:
		var player_panel: WaitingPlayerPanel = WAITING_PLAYER_PANEL.instantiate()
		var is_ready = _ready_players.any(func (id): return id == player.id)
		player_panel.init(player, is_ready)
		players.add_child(player_panel)
		all_players_ready = all_players_ready and (is_ready or player.is_server())
	
	if multiplayer.is_server():
		play_button.disabled = !all_players_ready || players_list.size() <= 1

func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		start_game.rpc()
	else:
		var is_ready = play_button.button_pressed
		play_button.release_focus()
		set_ready.rpc(is_ready)

@rpc("call_local", "reliable")
func start_game() -> void:
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

@rpc("any_peer", "call_local", "reliable")
func set_ready(ready: bool) -> void:
	prints(multiplayer.get_remote_sender_id(), "is ready")
	if ready:
		_ready_players.push_back(multiplayer.get_remote_sender_id())
	else:
		_ready_players.erase(multiplayer.get_remote_sender_id())
	_on_players_changed()

# TODO Garder ça ?
func _sort_by_pseudo(a: PlayerData, b: PlayerData) -> int:
	return a.pseudo < b.pseudo
