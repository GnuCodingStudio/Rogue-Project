class_name Collector
extends Area2D

var _targeted_collectable: Collectable

@onready var audio_player: AudioStreamPlayer = %AudioPlayer


#region built-in


func _process(delta: float) -> void:
	_target_nearest_resource()
	if Input.is_action_just_pressed("action_collect"):
		_collect_targeted_resource()

#endregion built-in

#region logic

func _target_nearest_resource() -> void:
	var collectables = get_overlapping_bodies().map(_get_collectable_or_null).filter(_not_null)
	collectables.sort_custom(_sort_by_distance)

	if collectables.size() > 0:
		var new_target = collectables[0]
		_set_targeted_collectable(new_target)
	else:
		_reset_targeted_resource()


func _get_collectable_or_null(body: Node2D) -> Collectable:
	var collectables = body.find_children("*", "Collectable", false)
	if not collectables.is_empty():
		if collectables[0].is_collectable():
			return collectables[0]
	return null


func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
	var distance_to_a = a.global_position.distance_to(self.global_position)
	var distance_to_b = b.global_position.distance_to(self.global_position)
	return (distance_to_a < distance_to_b)


func _not_null(node: Node2D) -> bool:
	return node != null

#endregion logic

#region private

func _set_targeted_collectable(target: Collectable) -> void:
	if target != _targeted_collectable:
		if _targeted_collectable != null:
			_targeted_collectable.unselect()
		target.select()
		_targeted_collectable = target


func _reset_targeted_resource() -> void:
	if _targeted_collectable != null:
		_targeted_collectable.unselect()
	_targeted_collectable = null


func _collect_targeted_resource() -> void:
	if _targeted_collectable != null:
		_targeted_collectable.collect()
		audio_player.play()

#endregion private
