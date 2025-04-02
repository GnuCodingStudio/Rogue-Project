extends Control

## TODO: this could be given dynamically when we have a boat scene
@export var weapons: Array[Weapon] = []

@onready var land_button: Button = %LandButton
@onready var weapons_container: HBoxContainer = %WeaponsContainer

var weapon_choice_button: PackedScene = load('res://scenes/menus/weapon/button/WeaponChoiceButton.tscn')

func _ready() -> void:
	land_button.visible = multiplayer.is_server()
	
	for weapon in weapons:
		var weapon_button: WeaponChoiceButton = weapon_choice_button.instantiate()
		weapon_button.init(weapon)
		
		weapons_container.add_child(weapon_button)
		weapon_button.on_pressed.connect(_on_weapon_selected)

@rpc("reliable", "any_peer", "call_local")
func _select_weapon(name: String):
	MultiplayerManager.set_weapon(multiplayer.get_remote_sender_id(), name)
	if MultiplayerManager.weapon_are_selected():
		land_button.disabled = false
		land_button.text = "WEAPON_CHOICE_LAND"
	else:
		land_button.disabled = true
		land_button.text = "WEAPON_CHOICE_SELECT_WEAPONS"

func _on_weapon_selected(weapon: Weapon):
	StoreManager.player_weapon = weapon
	print("Weapon selected by ", multiplayer.get_unique_id(), ": ", weapon.name, " - ", weapon)
	_select_weapon.rpc(weapon.name)
	
	for child in weapons_container.get_children():
		var weapon_button = child as WeaponChoiceButton
		weapon_button.set_selected_if_matching(weapon)

func _on_land_button_pressed() -> void:
	if !multiplayer.is_server(): return
	MultiplayerManager.begin_game()
