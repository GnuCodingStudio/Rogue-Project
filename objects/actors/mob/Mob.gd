class_name Mob
extends Actor

@onready var healthbar = $HealthBar
@onready var animationPlayer = %AnimationPlayer

var targeted_players: Array[Player]

func _ready():
	healthbar.init(_currentHealth)

func _on_hit():
	animationPlayer.play("Hit")
	healthbar.value = _currentHealth
	
func _on_death():
	animationPlayer.play("Death")
	set_physics_process(false)
