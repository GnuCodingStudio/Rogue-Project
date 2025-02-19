class_name Boat
extends StaticBody2D

var _can_enter = false

func _on_enter():
	if _can_enter:
		SceneTransition.change_scene("res://scenes/map/Map.tscn")
