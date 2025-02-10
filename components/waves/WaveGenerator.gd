class_name WaveGenerator
extends Node


@export var target_node: Node

@onready var timer: Timer = %Timer
# TODO Démarrage next vague par rapport à son "start_time" même si la vague précédente n'est pas finie ?

var _current_wave: int = 0
var _waves: Array[Wave] = []


func _ready() -> void:
	for child in get_children():
		if child is Wave:
			_waves.push_back(child)

	call_deferred("_start_wave", _waves[0])


func _start_wave(wave: Wave) -> void:
	wave.spawn(target_node)
	timer.start(wave.spawn_interval)


func _on_timer_timeout() -> void:
	var spawned = _waves[_current_wave].spawn(target_node)
	if not spawned:
		if _current_wave + 1 < _waves.size():
			_current_wave += 1
			_start_wave(_waves[_current_wave])
