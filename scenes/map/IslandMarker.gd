class_name IslandMarker 
extends Node2D

signal click(island_marker: IslandMarker)

@export var id: String
@export var enabled: bool = true:
	set(value): 
		enabled = value
		%Clickable.disabled = !value

func _on_click():
	if (enabled):
		click.emit(self)
