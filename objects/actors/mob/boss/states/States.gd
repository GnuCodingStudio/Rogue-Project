class_name States extends Node2D

var previous_state: State
var current_state: State:
	set(value):
		current_state = value
		debug_label.text = current_state.name

@onready var debug_label: Label = %Debug

func _ready() -> void:
	current_state = get_child(0)
	current_state.enter()

func change_state(new_state: State) -> void:
	previous_state = current_state
	current_state = new_state

	current_state.enter()
	previous_state.exit()
