class_name GlobalGameConsole
extends GameConsole


func _open_debug_level() -> void:
	SceneTransition.change_scene("res://scenes/levels/debug/DebugLevel.tscn")