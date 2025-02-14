class_name IslandMarker 
extends Node2D

signal click(island_marker: IslandMarker)

@onready var clickable = %Clickable

@export var id: String
@export var enabled: bool = true:
	set(value): 
		enabled = value
		clickable.disabled = !value


func _on_click():
	if (enabled):
		click.emit(self)
