class_name DummyMob
extends Mob

@onready var healthbar = %HealthBar
@onready var animationPlayer = %AnimationPlayer

func _ready():
	healthbar.init(_currentHealth)

func _on_hit():
	super._on_hit()
	healthbar.value = _currentHealth
	animationPlayer.play("Hit")
	
func _on_death():
	super._on_death()
	animationPlayer.play("Death")
