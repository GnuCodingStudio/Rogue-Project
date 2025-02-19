extends Control

@onready var weapon_icon: TextureRect = %WeaponIcon
@onready var weapon_name: Label = %WeaponName
@onready var damage_value_label: Label = %DamageValue
@onready var range_value_label: Label = %RangeValue
@onready var attack_speed_value_label: Label = %AttackSpeedValue

var _weapon: Weapon

func init(weapon):
	_weapon = weapon

func _ready() -> void:
	assert(_weapon != null, "The init function must be called")
	
	weapon_icon.texture = _weapon.icon
	weapon_name.text = _weapon.name
	damage_value_label.text = str(_weapon.attack_damage)
	range_value_label.text = str(_weapon.attack_range)
	attack_speed_value_label.text = str(_weapon.attack_speed)

func _on_button_pressed() -> void:
	StoreManager.player_weapon = _weapon
	print("Weapon selected is ", _weapon.name, " : ", _weapon)
	SceneTransition.change_scene("res://scenes/levels/islands/island.tscn")
