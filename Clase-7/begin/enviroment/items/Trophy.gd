extends Area2D

func _on_Trophy_body_entered(body):
	print("You win!")
	GameState.notify_level_won()
