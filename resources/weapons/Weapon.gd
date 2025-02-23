extends Resource
class_name Weapon

enum ATTACK_TYPES { projectile, melee }

@export var name: String = "Weapon"
@export var icon: Texture

@export_group("Attack", "attack_")
@export var attack_type: ATTACK_TYPES = ATTACK_TYPES.melee
@export var attack_damage: float = 1.0
@export var attack_range: float = 150.0
@export var attack_speed: float = 1.0
@export var attack_scene: PackedScene
@export var attack_offset: float = 0

func attackTo(direction: Vector2):
	var scene = attack_scene.instantiate()
	
	scene.init(attack_damage, attack_range, direction, attack_offset)
	return scene
