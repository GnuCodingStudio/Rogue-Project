class_name PlayerData
extends Node

var id: int = -1
var pseudo: String = "unknown"
var weapon: String

func _init(id: int, pseudo: String) -> void:
	self.id = id
	self.pseudo = pseudo

func is_server() -> bool:
	return id == 1
