extends Control


## TODO: this could be given dynamically when we have a boat scene
@export var weapons: Array[Weapon] = []; 

@onready var weapons_container: HBoxContainer = %WeaponsContainer
var weapon_choice_button: PackedScene = load('res://scenes/menus/weapon/button/WeaponChoiceButton.tscn')

func _ready() -> void:
	
	for weapon in weapons:
		var button = weapon_choice_button.instantiate()
		button.init(weapon)
		
		weapons_container.add_child(button)
		button.player_choose_weapon.connect(_players_is_ready)

func _players_is_ready():
	if !multiplayer.is_server(): return
	_load_island.rpc()

@rpc("call_local")
func _load_island() -> void:
	SceneTransition.change_scene("res://scenes/levels/islands/island.tscn")
