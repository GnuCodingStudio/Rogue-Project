class_name State extends Node2D

@onready var debug_label: Label = %Debug

func _ready() -> void:
	set_physics_process(false)

func enter() -> void:
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func transition() -> void:
	pass

func _physics_process(delta: float) -> void:
	transition()
	debug_label.text = name
