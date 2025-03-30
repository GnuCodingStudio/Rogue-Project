extends CanvasLayer

@onready var remainingTimeLabel: Label = %RemainingTime

var timer: SceneTreeTimer

func _process(delta):
	if (timer == null): return
	if (timer.time_left > 0):
		remainingTimeLabel.text = str(int(timer.time_left) % 60 + 1)

func start_timer():
	visible = true
	timer = get_tree().create_timer(5)
	await timer.timeout
	timer = null
	visible = false
