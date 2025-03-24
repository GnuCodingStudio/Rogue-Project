class_name Player
extends Actor

signal on_player_dead(player: Player)

@onready var attackTimer = $AttackTimer
@onready var sprite = $AnimatedSprite
@onready var player_name = %Label
@onready var camera = %Camera2D
@onready var healthbar: HealthBar = $HealthBar
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var life = 100
@export var weapon: Weapon
@export var chestModifierSpeed: float = 0.7

var hasChest = false

func _enter_tree():
	print("_enter_tree : ", str(name).to_int())
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if !is_multiplayer_authority(): return

	camera.make_current()

	if StoreManager.player_weapon != null:
		weapon = StoreManager.player_weapon

	healthbar.init(_currentHealth)
	attackTimer.wait_time = weapon.attack_speed

func _input(event):
	if !is_multiplayer_authority(): return

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
	animationPlayer.play("Hit")
	healthbar.value = _currentHealth
	
func _on_death():
	animationPlayer.play("Death")
	set_physics_process(false)
	on_player_dead.emit(self)

func get_speed():
	if hasChest: return _speed * chestModifierSpeed
	return _speed

func attack():
	if !_can_attack(): return
	
	var mouseCoords = get_global_mouse_position()
	var direction = global_position.direction_to(mouseCoords)
	_pop_attack.rpc(direction)

@rpc("call_local")
func _pop_attack(direction: Vector2):
	var attack_scene = weapon.attackTo(direction)

	if weapon.attack_type == Weapon.ATTACK_TYPES.projectile:
		attack_scene.global_position = global_position
		get_tree().get_root().get_node("Island").add_child(attack_scene)
	else:
		add_child(attack_scene)
	
	attackTimer.start()

func _on_collecting(element):
	if element is Chest:
		hasChest = true
	if element is Boat:
		if hasChest:
			element.can_enter = true
			animationPlayer.play("FadeAway")

			if element.can_enter: animationPlayer.play("FadeAway")

@rpc("any_peer", "call_local", "reliable")
func set_player_name(value: String) -> void:
	player_name.text = value

@rpc("any_peer", "call_local", "reliable")
func set_player_position(value: Vector2) -> void:
	position = value

func respawn():
	_currentHealth = _maxHealth
	healthbar.init(_maxHealth)
	set_physics_process(true)
	animationPlayer.play("Respawn")
	await animationPlayer.animation_finished
	isAlive = true
