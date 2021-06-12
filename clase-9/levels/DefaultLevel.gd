extends Node

signal restart_requested()
signal level_won()

#export (String) var next_level_path

func _ready():
	randomize()

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		_restart_level()

func _restart_level():
	emit_signal("restart_requested")

func game_won():
	emit_signal("level_won")
