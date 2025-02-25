extends Node2D

func _on_leave_level():
	SceneTransition.change_scene("res://scenes/map/Map.tscn")
