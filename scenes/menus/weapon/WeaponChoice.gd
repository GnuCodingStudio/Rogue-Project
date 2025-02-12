extends Control

## TODO: this could be given dynamically when we have a boat scene
@export var weapons: Array[Weapon] = []; 

@onready var weaponsContainer: HBoxContainer = %WeaponsContainer
var weapon_choice_button: PackedScene = load('res://scenes/menus/weapon/button/WeaponChoiceButton.tscn')

func _ready() -> void:
	for weapon in weapons:
		var button = weapon_choice_button.instantiate()
		button.init(weapon)
		
		weaponsContainer.add_child(button)

func _button_pressed(weaponSelected: Weapon):
	StoreManager.player_weapon = weaponSelected
	print("Weapon selected is ", weaponSelected.name, " : ", weaponSelected)
	SceneTransition.change_scene("res://scenes/levels/debug/DebugLevel.tscn")
