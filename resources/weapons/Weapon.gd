extends Resource
class_name Weapon

enum WeaponType {
	PROJECTILE,
	MELEE
}

@export var name: String = "Weapon"
@export var type: WeaponType = WeaponType.PROJECTILE

@export_group("Attack", "attack_")
@export var attack_damage: float = 1.0
@export var attack_range: float = 150.0
@export var attack_speed: float = 1.0
@export var attack_scene: PackedScene
@export var attack_offset: float = 0

func attackTo(direction: Vector2):
	var scene = attack_scene.instantiate()
	assert(scene is Projectile)
	
	scene.init(attack_damage, attack_range, direction)
	return scene
