extends ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value <= max_value / 10:
		modulate = 'e7001f'
	elif value <= max_value / 3:
		modulate = 'edae14'
	else:
		modulate = '3ac428'
	
