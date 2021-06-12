extends "res://entities/enemies/states/AbstractCatState.gd"

export (NodePath) var shoot_sfx_path
export (NodePath) var growl_sfx_path

onready var cooldown_timer = $FireCooldown
onready var shoot_sfx = get_node(shoot_sfx_path)
onready var growl_sfx = get_node(growl_sfx_path)

func enter():
	if cooldown_timer.is_stopped():
		shoot_sfx.play()
		parent.fire()
		cooldown_timer.start()
		parent._play_animation(animation_name)
	parent.velocity.x = 0

func exit():
	return

func update(delta):
	if parent.target != null && parent.can_see_target():
		parent.body_sprite.flip_h = parent.global_position.direction_to(parent.target.global_position).x < 0
	else:
		emit_signal("finished", CatStateMachine.STATES.IDLE)

func _on_animation_finished(anim_name:String):
	if anim_name == animation_name:
		parent._play_animation("idle")
	else:
		._on_animation_finished(anim_name)

func _on_FireCooldown_timeout():
	if parent.target != null && parent.can_see_target():
		shoot_sfx.play()
		parent.fire()
		cooldown_timer.start()
		parent._play_animation(animation_name)



func _on_Shoot_finished():
	growl_sfx.play()
