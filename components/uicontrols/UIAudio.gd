extends Node


var _ui_player := AudioStreamPlayer.new()


func _ready() -> void:
	_ui_player.bus = &"UI"
	add_child(_ui_player)


func play_ui(stream: AudioStream) -> void:
	_ui_player.stop()
	_ui_player.stream = stream
	_ui_player.play()
