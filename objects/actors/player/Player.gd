class_name Player
extends Actor

@export var chestModifierSpeed: float = 0.7

@onready var attackTimer = $AttackTimer

var weapon: Weapon
var hasChest = false

func _ready() -> void:
	weapon = StoreManager.player_weapon
	attackTimer.wait_time = weapon.attack_speed

func _input(event):
	if event is InputEventKey:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		moving_direction = direction.normalized()
		
	if event.is_action_pressed("attack"):
		attack()

func apply_attack(force: int) -> void:
	prints("Attacked with force", force)

func get_speed():
	if hasChest: return _speed * chestModifierSpeed
	
	return _speed

func attack():
	if not weapon: return
	if hasChest: return
	if attackTimer.time_left > 0: return
	
	var mouseCoords = get_global_mouse_position()
	var direction = global_position.direction_to(mouseCoords).normalized()
	
	var attack_scene = weapon.attackTo(direction)
	attack_scene.global_position = global_position + (direction * weapon.attack_offset)
	get_tree().current_scene.add_child(attack_scene)
	
	attackTimer.start()

func _on_collecting(element):
	if element is Chest:
		print('collected')
		hasChest = true
