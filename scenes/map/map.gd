extends Node2D

@onready var ship = %ShipSprite
@onready var island_0: Sprite2D = %Island0Sprite
@onready var island_1: Sprite2D = %Island1Sprite
@onready var island_2: Sprite2D = %Island2Sprite

var goal_island = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (goal_island != null):
		var island = _get_island(goal_island)
		ship.position = ship.position.lerp(island.position, delta)


func _on_island_clicked(island_id: int):
	print('Island '+str(island_id)+' clicked')
	goal_island = island_id


func _get_island(island_id: int) -> Sprite2D:
	if (island_id == 0):
		return island_0
	elif (island_id == 1):
		return island_1
	else: return island_2


func _on_island_entered(area: Area2D):
	SceneTransition.change_scene("res://scenes/levels/debug/DebugLevel.tscn")
