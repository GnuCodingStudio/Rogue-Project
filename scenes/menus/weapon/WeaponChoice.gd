extends Control

## TODO: this could be given dynamically when we have a boat scene
@export var weapons: Array[Weapon] = []

@onready var land_button: Button = %LandButton
@onready var weapons_container: HBoxContainer = %WeaponsContainer

var weapon_choice_button: PackedScene = load('res://scenes/menus/weapon/button/WeaponChoiceButton.tscn')

func _ready() -> void:
	if multiplayer.is_server():
		land_button.show()
	
	for i in weapons.size():
		var weapon = weapons[i]
		var button: WeaponChoiceButton = weapon_choice_button.instantiate()
		button.init(weapon)
		
		weapons_container.add_child(button)
		button.player_choose_weapon.connect(_on_weapon_selected.bind(i))

@rpc("reliable", "any_peer", "call_local")
func _select_weapon(id: int):
	# Ce if est nécessaire car le client courant n'a pas son entrée dans "get_players"
	if multiplayer.get_unique_id() != multiplayer.get_remote_sender_id():
		MultiplayerManager.get_player(multiplayer.get_remote_sender_id()).weapon = id
		_update_weapon_selection()

func _update_weapon_selection():
	for weapon_id in weapons_container.get_child_count():
		var weapon_button = weapons_container.get_child(weapon_id)
		var selectionner_players = MultiplayerManager.get_players().filter(func(p): return p.weapon == weapon_id)
		weapon_button.set_selectioners(selectionner_players)
	
	land_button.disabled = !MultiplayerManager.weapon_are_selected()

func _on_weapon_selected(id: int):
	_select_weapon.rpc(id)

func _on_land_button_pressed() -> void:
	if !multiplayer.is_server(): return
	MultiplayerManager.begin_game()
