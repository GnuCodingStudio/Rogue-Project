extends ProgressBar

var RED_COLOR = "e7001f"
var ORANGE_COLOR = "edae14"
var GREEN_COLOR = "3ac428"

func _process(delta):
	if value <= max_value / 10:
		modulate = RED_COLOR
	elif value <= max_value / 3:
		modulate = ORANGE_COLOR
	else:
		modulate = GREEN_COLOR
	
