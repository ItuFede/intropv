extends Area2D

onready var animation_player = $AnimationPlayer

func _on_GreenGem_body_entered(body):
	if body is Player:
		body.notify_hit(1)
		collision_layer = 0
		collision_mask = 0
		animation_player.play("remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()
