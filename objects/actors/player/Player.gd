class_name Player
extends Actor

@export var chestModifierSpeed: float = 0.7
@export var weapon: Weapon

@onready var attackTimer = $AttackTimer
@onready var healthbar: HealthBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var hasChest = false

func _ready() -> void:
	if StoreManager.player_weapon != null:
		weapon = StoreManager.player_weapon
	healthbar.init(_currentHealth)
	attackTimer.wait_time = weapon.attack_speed

func _input(event):
	if event is InputEventKey:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		moving_direction = direction.normalized()
		
	if event.is_action_pressed("attack"):
		attack()

func _can_attack() -> bool:
	if not weapon: return false
	if hasChest: return false
	if _currentHealth <= 0: return false
	if attackTimer.time_left > 0: return false

	return true

func _on_hit():
	animation_player.play("Hit")
	healthbar.value = _currentHealth
	
func _on_death():
	animation_player.play("Death")
	set_physics_process(false)

func get_speed():
	if hasChest: return _speed * chestModifierSpeed
	
	return _speed

func attack():
	if !_can_attack(): return
	
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
			animation_player.play("FadeAway")

		if element.can_enter: animation_player.play("FadeAway")
