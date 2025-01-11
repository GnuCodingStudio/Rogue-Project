@tool
extends Panel

@export var text: String
@export_category("Buttons")
@export var confirmButtonText: String
@export var cancelButtonText: String

signal on_confirm()
signal on_cancel()


@onready var text_label = %TextLabel
@onready var confirm_button = %ConfirmButton
@onready var cancel_button = %CancelButton


func _ready():
	text_label.text = text
	confirm_button.text = confirmButtonText
	cancel_button.text = cancelButtonText


func pop_in():
	super.show()
	confirm_button.grab_focus()


func _on_confirm_button_pressed():
	hide()
	on_confirm.emit()


func _on_cancel_button_pressed():
	hide()
	on_cancel.emit()
