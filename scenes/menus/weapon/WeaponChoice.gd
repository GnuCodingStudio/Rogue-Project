extends Control

## TODO: this could be given dynamically when we have a boat scene
@export var weapons: Array[Weapon] = []; 

@onready var weaponsContainer: HBoxContainer = %WeaponsContainer

func _ready() -> void:
	for weapon in weapons:
		var center = CenterContainer.new()
		var vBox = VBoxContainer.new()
		var icon = TextureRect.new()
		var button = Button.new()
		
		icon.texture = weapon.icon
		icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		
		button.text = weapon.name
		button.add_theme_font_size_override("font_size", 16)
		button.pressed.connect(_button_pressed.bind(weapon))
		
		vBox.add_child(icon)
		vBox.add_child(button)
		
		center.add_child(vBox)
		
		weaponsContainer.add_child(center)

func _button_pressed(weaponSelected: Weapon):
	StoreManager.player_weapon = weaponSelected
	print("Weapon selected is ", weaponSelected.name, " : ", weaponSelected)
	SceneTransition.change_scene("res://scenes/levels/debug/DebugLevel.tscn")
