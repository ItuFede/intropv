extends "res://entities/state.gd"

# Initialize the state. E.g. change the animation
func enter():
	parent._play_animation("dead")
	parent.raycast.collision_mask = 0

# warning-ignore:unused_argument
func _on_animation_finished(anim_name):
	if anim_name == "dead":
		parent.remove_anim_player.play("remove")

