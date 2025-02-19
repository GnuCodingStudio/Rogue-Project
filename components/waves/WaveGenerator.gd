class_name WaveGenerator
extends Node

@export var target_node: Node

var _waves: Array[Wave] = []

func _ready() -> void:
	for child in get_children():
		if child is Wave:
			_waves.push_back(child)
			_setup_wave(child)

func _setup_wave(wave: Wave) -> void:
	prints("Setting up wave", wave.name)
	wave.init(target_node)
	wave.on_start.connect(_on_wave_start)
	var wave_timer = get_tree().create_timer(wave.start_time)
	wave_timer.timeout.connect(_start_wave.bind(wave))

func _start_wave(wave: Wave) -> void:
	wave.start()

func _on_wave_start(wave: Wave) -> void:
	if wave.trigger_previous_waves:
		prints("Starting all waves before", wave.name)
		var wave_position = _waves.find(wave)
		for i in wave_position:
			_waves[i].start()
