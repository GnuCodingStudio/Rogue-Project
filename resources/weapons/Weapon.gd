extends Resource
class_name Weapon

enum WeaponType {
	PROJECTILE,
	MELEE
}

@export var name: String = "Weapon"
@export var type: WeaponType = WeaponType.PROJECTILE
@export var damage: float = 1.0
@export var attack_speed: float = 1.0
@export var range: float = 150.0

@export var attack_scene: PackedScene

func initTo(direction: Vector2):
	var scene = attack_scene.instantiate()
	assert(scene is Attack)
	
	scene.init(damage, range, direction)
	return scene
