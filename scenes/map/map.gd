extends Node2D

@onready var ship = %ShipSprite

var ship_speed: int = 70


func _on_island_clicked(island_marker: IslandMarker):
	prints("Island ", str(island_marker.id), " clicked")
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ship, "position", island_marker.position, 2)
	tween.tween_callback(_on_island_entered)


func _on_island_entered():
	SceneTransition.change_scene("res://scenes/levels/debug/DebugLevel.tscn")
