class_name State extends Node2D

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func transition() -> void:
	pass

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		transition()
