class_name Chest
extends StaticBody2D

func _on_collect():
	$AnimationPlayer.play("fade_out")
