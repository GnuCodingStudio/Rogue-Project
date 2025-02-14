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
