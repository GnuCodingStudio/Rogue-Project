class_name Magnetable
extends Node


#region built-in

func _ready() -> void:
	assert(get_parent() is RigidBody2D, "Only RigidBody2D and sub-classes can be magnetable")

#endregion built-in
