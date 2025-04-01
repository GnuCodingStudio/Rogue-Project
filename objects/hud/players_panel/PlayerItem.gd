class_name PlayerItem
extends HBoxContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

const GUN_ICON = preload("res://resources/weapons/gun/GunIcon.png")
const SWORD_ICON = preload("res://resources/weapons/sword/SwordIcon.png")
const STEERING_WHEEL_ICON = preload("res://resources/weapons/steering_wheel/SteeringWheelIcon.png")

var _player: PlayerData

func init(player: PlayerData) -> void:
	_player = player

func _ready() -> void:
	texture_rect.texture = _get_weapon_texture(_player)
	label.text = _player.pseudo

func _get_weapon_texture(player: PlayerData) -> Texture2D:
	if player.weapon == "WEAPON_GUN":
		return GUN_ICON
	elif _player.weapon == "WEAPON_SWORD":
		return SWORD_ICON
	return STEERING_WHEEL_ICON
