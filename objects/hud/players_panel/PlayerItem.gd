class_name PlayerItem
extends HBoxContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var _player: PlayerData

func init(player: PlayerData) -> void:
	_player = player

func _ready() -> void:
	label.text = _player.pseudo + "//" + str(_player.weapon)
