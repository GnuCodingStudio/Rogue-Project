extends Actor
class_name Player

@export var current_weapon: Weapon

func _input(event):
	if event is InputEventKey:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		moving_direction = direction.normalized()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			attack()

func apply_attack(force: int) -> void:
	prints("Attacked with force", force)


func attack():
	if not current_weapon: return
	
	var mouseCoords = get_global_mouse_position()
	var direction = global_position.direction_to(mouseCoords).normalized()
	
	var attack_scene = current_weapon.initTo(direction)
	attack_scene.global_position = global_position + (direction * 50)
	get_tree().current_scene.add_child(attack_scene)
