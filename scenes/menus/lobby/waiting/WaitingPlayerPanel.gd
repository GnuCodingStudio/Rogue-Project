class_name WaitingPlayerPanel
extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var name_label: Label = %NameLabel

const _CAPTAIN_ICON = preload("res://scenes/menus/lobby/waiting/captain.png")
const _READY_ICON = preload("res://scenes/menus/lobby/waiting/ready.png")
const _WAITING_ICON = preload("res://scenes/menus/lobby/waiting/waiting.png")

var _WAITING_COLOR = Color(1., 1., 1., .3)
var _READY_COLOR = Color.WHITE

var _player: PlayerData
var _is_ready: bool

func init(player: PlayerData, is_ready: bool) -> void:
	_player = player
	_is_ready = is_ready

func _ready() -> void:
	assert(_player != null, "The init function must be called first")
	name_label.text = _player.pseudo
	if _player.is_server():
		texture_rect.texture = _CAPTAIN_ICON
	else:
		if _is_ready:
			texture_rect.texture = _READY_ICON
			texture_rect.self_modulate = _READY_COLOR
			self_modulate = _READY_COLOR
		else:
			texture_rect.texture = _WAITING_ICON
			texture_rect.self_modulate = _WAITING_COLOR
			self_modulate = _WAITING_COLOR
