class_name Death extends State

@onready var _boss: Boss = owner
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var health_bar: HealthBar = %HealthBar

func enter() -> void:
	super.enter()
	health_bar.hide()
	animated_sprite.play("Death" + _boss._direction_name())
