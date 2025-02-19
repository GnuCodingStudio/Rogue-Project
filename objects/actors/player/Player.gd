class_name Player
extends Actor

@export var chestModifierSpeed: float = 0.7
@export var maxHealth = 100
var lifePoint = maxHealth

@onready var attackTimer = $AttackTimer
@onready var healthbar = $HealthBar

@export var weapon: Weapon
var hasChest = false

func _ready() -> void:
	if StoreManager.player_weapon != null:
		weapon = StoreManager.player_weapon
	healthbar.max_value = maxHealth
	healthbar.value = maxHealth
	attackTimer.wait_time = weapon.attack_speed

func _input(event):
	if event is InputEventKey:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		moving_direction = direction.normalized()
		
	if event.is_action_pressed("attack"):
		attack()

func apply_attack(force: int) -> void:
	if lifePoint == 0:
		return

	lifePoint -= force
	$AnimationPlayer.play('Hit')
	healthbar.value = lifePoint

	if (lifePoint == 0):
		$AnimationPlayer.play("Death")

func get_speed():
	if hasChest: return _speed * chestModifierSpeed
	
	return _speed

func attack():
	if not weapon: return
	if hasChest: return
	if attackTimer.time_left > 0: return
	
	var mouseCoords = get_global_mouse_position()
	var direction = global_position.direction_to(mouseCoords)
	
	var attack_scene = weapon.attackTo(direction)

	if weapon.attack_type == Weapon.ATTACK_TYPES.projectile:
		attack_scene.global_position = global_position
		get_tree().current_scene.add_child(attack_scene)
	else:
		add_child(attack_scene)
	
	attackTimer.start()

func _on_collecting(element):
	if element is Chest:
		hasChest = true
	if element is Boat:
		if hasChest:
			element.can_enter = true
			$AnimationPlayer.play("fade_away")

		if element.can_enter: $AnimationPlayer.play("fade_away")

