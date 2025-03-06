class_name IslandMarker 
extends Node2D

signal click(island_marker: IslandMarker)

@export var id: int
@export var enabled: bool = true:
	set(value): 
		enabled = value
		%Clickable.disabled = !value

func _ready():
	if !multiplayer.is_server():
		%Clickable.queue_free()

func _on_click():
	if (enabled):
		click.emit(self)
		
func disable():
	enabled = false
	modulate = Color.DIM_GRAY
