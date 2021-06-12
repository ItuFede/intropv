extends "res://entities/player/StateMachine.gd"

enum STATES {
	IDLE,
	WALK,
	JUMP,
	DEAD,
	RUN,
	ROLL
}

var animations_map:Dictionary = {
	STATES.IDLE: "idle",
	STATES.WALK: "walk",
	STATES.JUMP: "jump",
	STATES.DEAD: "dead",
	STATES.ROLL: "roll"
}

func initialize(parent):
	.initialize(parent)
	call_deferred("set_state", STATES.IDLE)

func _state_logic(delta):
	
	if state != STATES.DEAD:
		parent._handle_cannon_actions()
	else:
		parent._handle_cannon_actions(false)
		parent.move_direction = 0
	
	if state == STATES.ROLL:
		var direction = parent.move_direction
		parent.move_direction = direction if direction != 0 else 1 - (int(parent.body.flip_h) * 2)
	elif ![STATES.IDLE, STATES.DEAD].has(state):
		parent._handle_move_input()
	
	if state == STATES.JUMP && Input.is_action_just_pressed("jump") && parent.jumps < 2:
		parent.snap_vector = Vector2.ZERO
		parent.velocity.y = -parent.jump_speed
		parent.jumps += 1
		parent._play_animation(animations_map[state])
	
	if state == STATES.RUN || (state == STATES.JUMP && Input.is_action_pressed("run")):
		parent._handle_acceleration(2)
	else:
		parent._handle_acceleration()
	parent._apply_movement()

func _get_transition(delta):
	
	if state != STATES.DEAD && PlayerData.current_health == 0:
		parent.emit_signal("dead")
		return STATES.DEAD
	if Input.is_action_just_pressed("jump") && [STATES.IDLE, STATES.WALK, STATES.RUN].has(state) && (parent.is_on_floor() || parent.jumps < 2):
		parent.snap_vector = Vector2.ZERO
		parent.velocity.y = -parent.jump_speed
		parent.jumps += 1 * (1 + int(!parent.is_on_floor()))
		return STATES.JUMP
	if Input.is_action_just_pressed("roll") && [STATES.IDLE, STATES.WALK, STATES.RUN].has(state):
		return STATES.ROLL
	
	match state:
		STATES.IDLE:
			if int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")) != 0:
				if Input.is_action_pressed("run"):
					return STATES.RUN
				else:
					return STATES.WALK
		STATES.WALK:
			if parent.move_direction == 0:
				return STATES.IDLE
			elif Input.is_action_pressed("run"):
				return STATES.RUN
		STATES.RUN:
			if !Input.is_action_pressed("run"):
				if parent.move_direction == 0:
					return STATES.IDLE
				else:
					return STATES.WALK
		STATES.JUMP:
			if parent.is_on_floor():
				if parent.velocity.y < 0:
					parent.velocity.y *= 0.3
				parent.jumps = 0
				if parent.move_direction != 0:
					return STATES.WALK
				else:
					return STATES.IDLE
		STATES.ROLL:
			if !parent._is_animation_playing(animations_map[STATES.ROLL]):
				if parent.move_direction == 0:
					return STATES.IDLE
				elif Input.is_action_pressed("run"):
					return STATES.RUN
				else:
					return STATES.WALK
	
	return null

func _enter_state(new_state, old_state):
	if [STATES.RUN, STATES.WALK].has(new_state):
		parent._play_animation(animations_map[STATES.WALK], false, 2.0 if state == STATES.RUN else 1.0)
	elif new_state == STATES.ROLL:
		parent._play_animation(animations_map[new_state], true, 1.0, parent.body.flip_h)
	else:
		parent._play_animation(animations_map[new_state])

func _exit_state(old_state, new_state):
	pass


func handle_hit(amount):
	if state != STATES.ROLL:
		parent._receive_damage(amount)

func handle_fatal_hit():
	parent._receive_damage(-PlayerData.current_health)
