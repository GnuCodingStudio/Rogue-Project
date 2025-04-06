class_name WaitingPlayerPanel
extends PanelContainer

@onready var name_label: Label = %NameLabel

var _player: PlayerData

func init(player: PlayerData) -> void:
	_player = player

func _ready() -> void:
	assert(_player != null, "The init function must be called first")
	%NameLabel.text = _player.pseudo
