extends Control

@onready var quit_dialog = %QuitDialog
@onready var start_button: Button = %StartButton

func _ready():
	ProgressionService.init()
	start_button.grab_focus()

func _on_start_button_pressed():
	MultiplayerManager.init_soloplayer()
	SceneTransition.change_scene("res://scenes/map/Map.tscn")

func _on_create_crew_button_pressed() -> void:
	MultiplayerManager.init_multiplayer()
	SceneTransition.change_scene("res://scenes/menus/lobby/host/HostLobby.tscn")

func _on_multiplayer_button_pressed() -> void:
	MultiplayerManager.init_multiplayer()
	SceneTransition.change_scene("res://scenes/menus/lobby/join/JoinLobby.tscn")

func _on_credits_button_pressed():
	SceneTransition.change_scene("res://scenes/menus/credits/CreditsMenu.tscn")

func _on_quit_button_pressed():
	_ask_to_confirm_quit()

func _on_quit_dialog_confirmed():
	get_tree().quit()

func _ask_to_confirm_quit():
	quit_dialog.pop_in()
