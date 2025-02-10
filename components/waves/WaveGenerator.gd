class_name WaveGenerator
extends Node

@export var target_node: Node

func _ready() -> void:
	for child in get_children():
		if child is Wave:
			_setup_wave(child)

func _setup_wave(wave: Wave) -> void:
	prints("Setting up wave", wave.name)
	var wave_timer = get_tree().create_timer(wave.start_time)
	wave_timer.timeout.connect(_start_wave.bind(wave))

func _start_wave(wave: Wave) -> void:
	wave.start(target_node)
