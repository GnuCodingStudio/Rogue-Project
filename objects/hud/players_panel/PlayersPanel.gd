extends PanelContainer

@onready var players_container: VBoxContainer = %PlayersContainer
const PLAYER_ITEM = preload("res://objects/hud/players_panel/PlayerItem.tscn")

func _ready() -> void:
	MultiplayerManager.player_list_changed.connect(_on_players_changed)


func _on_players_changed() -> void:
	for p in players_container.get_children(): p.queue_free()
	for player in MultiplayerManager.get_players():
		var player_node = PLAYER_ITEM.instantiate()
		player_node.init(player)
		players_container.add_child(player_node)
