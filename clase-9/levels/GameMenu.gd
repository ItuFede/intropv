extends CanvasLayer

signal restart_requested()
signal exit_requested()

onready var menu = $Control
onready var input_timer = $InputTimer

var can_pause:bool = false

func _unhandled_input(event):
	if can_pause && Input.is_action_just_pressed("pause") && input_timer.is_stopped():
		var is_visible = menu.visible
		menu.visible = !is_visible
		get_tree().paused = !is_visible
		input_timer.start()
		


func _on_Continue_button_up():
	menu.hide()
	get_tree().paused = false


func _on_Restart_button_up():
	menu.hide()
	get_tree().paused = false
	emit_signal("restart_requested")


func _on_Exit_button_up():
	menu.hide()
	get_tree().paused = false
	emit_signal("exit_requested")
