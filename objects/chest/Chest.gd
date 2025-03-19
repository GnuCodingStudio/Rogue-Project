class_name Chest
extends StaticBody2D

func _on_collect():
	$AnimationPlayer.play("fade_out")

func drop(playerPosition: Vector2):
	position = playerPosition
	$AnimationPlayer.play("fade_in")
