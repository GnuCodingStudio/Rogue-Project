class_name Chest
extends StaticBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _on_collect():
	animationPlayer.play("fade_out")
	collision_layer = 0

func drop(playerGlobalPosition: Vector2):
	global_position = playerGlobalPosition
	animationPlayer.play("fade_in")
	collision_layer = 4
