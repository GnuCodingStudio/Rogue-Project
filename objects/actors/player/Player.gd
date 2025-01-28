extends Actor
class_name Player

@export var projectile: PackedScene

func _input(event):
	if event is InputEventKey:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		moving_direction = direction.normalized()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			attack(get_global_mouse_position())

func apply_attack(force: int) -> void:
	prints("Attacked with force", force)

func attack(target_position: Vector2):
	if not projectile: return
	
	var projectile_instance = projectile.instantiate()
	var direction = global_position.direction_to(target_position)
	projectile_instance.global_position = global_position + (direction * 20)
	
	projectile_instance.targeted_direction = direction
	
	get_tree().current_scene.add_child(projectile_instance)
