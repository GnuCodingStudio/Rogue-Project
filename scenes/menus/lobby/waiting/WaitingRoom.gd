extends Control

@onready var play_button: Button = %StartButton
@onready var players: GridContainer = %Players

const WAITING_PLAYER_PANEL = preload("res://scenes/menus/lobby/waiting/WaitingPlayerPanel.tscn")

func _ready() -> void:
	if multiplayer.is_server():
		play_button.text = "WAITING_START_BUTTON"
	else:
		play_button.text = "WAITING_READY_BUTTON"
	MultiplayerManager.player_list_changed.connect(_on_players_changed)
	_on_players_changed()

func _on_players_changed() -> void:
	for c in players.get_children(): c.queue_free()
	for player in MultiplayerManager.get_players():
		var player_panel: WaitingPlayerPanel = WAITING_PLAYER_PANEL.instantiate()
		player_panel.init(player)
		players.add_child(player_panel)
	# TODO Instancier des WaitingPlayerPanel

func _on_start_button_pressed() -> void:
	if multiplayer.is_server():
		start_game.rpc()
	else:
		set_ready.rpc()

@rpc("call_local", "reliable")
func start_game() -> void:
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

@rpc("any_peer", "reliable")
func set_ready() -> void:
	prints(multiplayer.get_remote_sender_id(), "is ready")
	# TODO Marquer le joueur comme prêt
	_on_players_changed()

# TODO Garder ça ?
func _sort_by_pseudo(a: PlayerData, b: PlayerData) -> int:
	return a.pseudo < b.pseudo
