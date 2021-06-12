extends Camera2D

onready var anim_player = $AnimationPlayer

func _on_Player_ice_started():
	anim_player.play("vibrate")


func _on_Player_ice_stopped():
	anim_player.stop()
	offset = Vector2.ZERO
	zoom = Vector2.ONE
