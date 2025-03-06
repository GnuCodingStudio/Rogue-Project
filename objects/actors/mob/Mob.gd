class_name Mob
extends Actor

@onready var healthbar = $HealthBar
@onready var animationPlayer = %AnimationPlayer

@export var maxHealth: int = 10
@export var currentHealth: int = maxHealth

var targeted_players: Array[Player]

func _ready():
	healthbar.init(currentHealth)

func apply_attack(damage: int):	
	if currentHealth <= 0: return
	
	currentHealth -= damage
	healthbar.value = currentHealth
	animationPlayer.play("Hit")
	
	if currentHealth <= 0:
		animationPlayer.play("Death")
		set_physics_process(false)
