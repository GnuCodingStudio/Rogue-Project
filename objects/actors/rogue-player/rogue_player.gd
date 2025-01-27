extends CharacterBody2D
class_name RoguePlayer

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite
@onready var player_name = $PlayerName

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	$Camera2D.make_current()
		
	# display the ID for each player : OS name or Player name
	if GlobalVariables.player_name == "Player" and OS.has_environment("USERNAME"):
		player_name.text = OS.get_environment("USERNAME")
	else: 
		player_name.text = GlobalVariables.player_name

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump only if the player is on floor
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Direction
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		#right
		animated_sprite.flip_h = true
	elif direction < 0:
		#left
		animated_sprite.flip_h = false
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Move")
	else:
		animated_sprite.play("Jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
