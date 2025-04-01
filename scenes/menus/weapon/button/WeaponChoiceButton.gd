class_name WeaponChoiceButton
extends Control

signal on_pressed(weapon: Weapon)

@onready var weapon_icon: TextureRect = %WeaponIcon
@onready var weapon_name: Label = %WeaponName
@onready var damage_value_label: Label = %DamageValue
@onready var range_value_label: Label = %RangeValue
@onready var attack_speed_value_label: Label = %AttackSpeedValue

var _weapon: Weapon

var _NORMAL_COLOR = Color.WHITE
var _SELECTED_COLOR = Color(0.565, 0.0, 0.969, 1.0)

func init(weapon):
	_weapon = weapon

func _ready() -> void:
	assert(_weapon != null, "The init function must be called")
	
	weapon_icon.texture = _weapon.icon
	weapon_name.text = _weapon.name
	damage_value_label.text = str(_weapon.attack_damage)
	range_value_label.text = str(_weapon.attack_range)
	attack_speed_value_label.text = str(_weapon.attack_speed)

func set_selected_if_matching(weapon: Weapon) -> void:
	if weapon == _weapon:
		self_modulate = _SELECTED_COLOR
	else:
		self_modulate = _NORMAL_COLOR

func _on_button_pressed() -> void:
	on_pressed.emit(_weapon)
