extends Control

@onready var play_button: Button = %StartButton
@onready var players_list: ItemList = %PlayersList

# TODO Gérer les erreurs envoyées par MultiplayerManager.game_error

func _ready() -> void:
	play_button.visible = multiplayer.is_server()
	MultiplayerManager.player_list_changed.connect(_on_players_changed)
	_on_players_changed()

func _on_players_changed() -> void:
	var players := MultiplayerManager.get_players()

	players.sort_custom(_sort_by_pseudo)
	players_list.clear()
	for player in players:
		if player.id == multiplayer.get_unique_id():
			players_list.add_item(player.pseudo + " (you)")
		else:
			players_list.add_item(player.pseudo)

func _on_start_button_pressed() -> void:
	start_game.rpc()

@rpc("call_local", "reliable")
func start_game() -> void:
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

func _sort_by_pseudo(a: PlayerData, b: PlayerData) -> int:
	return a.pseudo < b.pseudo
