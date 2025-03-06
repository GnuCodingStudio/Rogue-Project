class_name Mob
extends Actor

@onready var healthbar = $HealthBar
@onready var animationPlayer = %AnimationPlayer

@export var maxHealth: int = 10

var targeted_players: Array[Player]
var lifePoint: int = maxHealth

func _ready():
	healthbar.value = maxHealth
	healthbar.max_value = maxHealth

func apply_attack(damage: int):	
	if lifePoint <= 0: return
	
	lifePoint -= damage
	healthbar.value = lifePoint
	animationPlayer.play("Hit")
	
	if lifePoint <= 0:
		animationPlayer.play("Death")
