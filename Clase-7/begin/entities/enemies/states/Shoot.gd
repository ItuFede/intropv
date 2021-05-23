extends "res://entities/state.gd"

onready var cooldown_timer = $FireCooldown

func enter():
	parent.velocity.x = 0
	parent.fire()
	cooldown_timer.start()
	parent._play_animation("shoot")

func exit():
	return

func update(delta):
	if parent.target != null && parent.can_see_target():
		parent.body_sprite.flip_h = parent.global_position.direction_to(parent.target.global_position).x < 0
	else:
		emit_signal("finished", CatStateMachine.STATES.IDLE)

func _on_animation_finished(anim_name):
	if anim_name == "shoot":
		parent._play_animation("idle")

func _on_FireCooldown_timeout():
	if parent.target != null && parent.can_see_target():
		parent.fire()
		cooldown_timer.start()
		parent._play_animation("shoot")
