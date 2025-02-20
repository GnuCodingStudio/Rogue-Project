extends Node2D

@onready var ship: Sprite2D = %ShipSprite
@export var ship_speed: int = 70

func _on_island_clicked(island_marker: IslandMarker):
	if !multiplayer.is_server(): return
	prints("Island", island_marker.id, "clicked")
	rpc("_navigate_to_island", island_marker.position)

@rpc("call_local")	
func _navigate_to_island(target_position: Vector2) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ship, "position", target_position, 2)
	tween.tween_callback(_on_island_entered)

func _on_island_entered():
	load_weapon_screen.rpc()
	
@rpc("call_local")
func load_weapon_screen() -> void:
	SceneTransition.change_scene("res://scenes/menus/weapon/WeaponChoice.tscn")
