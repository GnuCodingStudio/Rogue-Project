class_name Mob
extends Actor

var targeted_players: Array[Player]
	
func _on_death():
	super._on_death()
	set_physics_process(false)
	_disable_collision()

func _disable_collision() -> void:
	collision_layer = 0
	collision_mask = 0
