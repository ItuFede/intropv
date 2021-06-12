extends Node


func _on_ExitButton_button_up():
	get_tree().quit()

func _on_PlayButton_button_up():
	get_tree().change_scene("res://levels/LevelsManager.tscn")
