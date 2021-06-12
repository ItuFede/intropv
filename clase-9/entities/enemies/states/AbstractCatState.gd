extends "res://entities/state.gd"

export (String) var animation_name

func notify_hit(amount):
	parent.health -= amount
	if parent.health <= 0:
		emit_signal("finished", CatStateMachine.STATES.DEAD)
	else:
		parent._play_animation("hit")

func _on_animation_finished(anim_name:String):
	if anim_name == "hit":
		parent._play_animation(animation_name)
