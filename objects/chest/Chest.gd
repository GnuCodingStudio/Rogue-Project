class_name Chest
extends StaticBody2D

func _on_collect():
	$AnimationPlayer.play("fade_out")
	collision_layer = 0

func drop(playerGlobalPosition: Vector2):
	global_position = playerGlobalPosition
	$AnimationPlayer.play("fade_in")
	collision_layer = 4
