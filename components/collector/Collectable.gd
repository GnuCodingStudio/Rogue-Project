class_name Collectable
extends Node2D


signal on_select()
signal on_unselect()
signal on_collect()

var _collectable: bool = false


func select() -> void:
	on_select.emit()


func unselect() -> void:
	on_unselect.emit()


func collect() -> void:
	on_collect.emit()


func set_collectable(collectable: bool) -> void:
	_collectable = collectable


func is_collectable() -> bool:
	return _collectable
