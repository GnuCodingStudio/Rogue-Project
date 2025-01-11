extends VBoxContainer


@export var title: String
@export var author: String
@export var link: String
@export var link_text: String

@onready var titleLabel = %Title
@onready var linkButton = %LinkButton


func _ready():
	titleLabel.text = tr("CREDITS_TITLE_N_AUTHOR").format({"title": title, "author": author})
	linkButton.text = link_text if link_text != null else link
	linkButton.uri = link
