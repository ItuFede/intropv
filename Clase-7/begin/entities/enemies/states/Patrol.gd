extends "res://entities/state.gd"

export (Vector2) var wander_radius
export (float) var minimum_wander_distance
export (float) var speed
export (float) var max_h_speed

var path:Array = []

func enter():
	var random_point:Vector2 = parent.global_position + Vector2(rand_range(-wander_radius.x, wander_radius.x), rand_range(-wander_radius.y, wander_radius.y))
	path = parent.navigation.get_simple_path(parent.global_position, random_point)
	if path.empty() || parent.global_position.distance_to(path.back()) < minimum_wander_distance:
		emit_signal("finished", CatStateMachine.STATES.IDLE)
		return
	parent._play_animation("walk")

func exit():
	path = []

func update(delta):
	if path.empty():
		emit_signal("finished", CatStateMachine.STATES.IDLE)
		return
	elif parent.target != null && parent.can_see_target():
		emit_signal("finished", CatStateMachine.STATES.SHOOT)
		return
	var next_point:Vector2 = path.front()
	while parent.global_position.distance_to(next_point) < 32:
		path.pop_front()
		if path.empty():
			emit_signal("finished", CatStateMachine.STATES.IDLE)
			return
		else:
			next_point = path.front()
	parent.velocity.x = clamp((parent.velocity.x + parent.global_position.direction_to(next_point).x * speed), -max_h_speed, max_h_speed)
	parent._apply_movement()
	
	parent.body_sprite.flip_h =  parent.velocity.x < 0
