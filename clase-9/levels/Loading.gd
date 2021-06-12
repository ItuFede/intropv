extends CanvasLayer

onready var dots = $ColorRect/HBoxContainer/dots
onready var timer = $Timer
onready var rect = $ColorRect

func start_animation():
	rect.show()
	timer.start()

func stop_animation():
	rect.hide()
	timer.stop()
	dots.text = ""

func _on_Timer_timeout():
	var amount_dots:int = (dots.text.length() + 1) % 4
	dots.text = ""
	for i in amount_dots:
		dots.text += "."
