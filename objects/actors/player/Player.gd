extends Actor
class_name Player


func _input(event):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	moving_direction = direction.normalized()
