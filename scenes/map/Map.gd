extends Node2D

@onready var ship: Sprite2D = %ShipSprite
@export var ship_speed: int = 70

func _ready():
	var current_island = StoreManager.current_island;
	var children = get_children();
	for child in children:
		if not child is IslandMarker: continue
		if child.id <= current_island:
			child.disable()
		if child.id == current_island:
			ship.global_position = child.global_position

func _on_island_clicked(island_marker: IslandMarker):
	prints("Island", island_marker.id, "clicked")
	_update_current_island.rpc(island_marker.id)
	_navigate_to_island.rpc(island_marker.position)

@rpc("call_local")	
func _navigate_to_island(target_position: Vector2) -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ship, "position", target_position, 2)
	tween.tween_callback(_on_island_entered)

func _on_island_entered():
	_load_weapon_screen.rpc()
	
@rpc("call_local")
func _load_weapon_screen() -> void:
	SceneTransition.change_scene("res://scenes/menus/weapon/WeaponChoice.tscn")

@rpc("call_local")
func _update_current_island(id: int) -> void:
	StoreManager.current_island = id
