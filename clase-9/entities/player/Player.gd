extends KinematicBody2D
class_name Player

signal hit()
signal dead()
signal ice(x,y)
signal ice_started()
signal ice_stopped()

onready var outPutStreamPlayer = $PlayerOutput
onready var cannon = $Body/Cannon
onready var sm = $StateMachine
onready var player_animation = $PlayerAnimation
onready var body = $Body
onready var floor_raycasts:Array = $FloorRaycasts.get_children()
onready var state_machine:StateMachine = $StateMachine
onready var ray_effect = $RayPower
onready var shield_effect = $Shield
onready var ray_sfx = $PowerSFX

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_LENGTH := 32.0
const SLOPE_THRESHOLD := deg2rad(60)

export (int) var max_health = 2
export (float) var ACCELERATION:float = 30.0
export (float) var H_SPEED_LIMIT:float = 400.0
export (int) var jump_speed = 1000
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 30
export (int) var RECOIL = 25

var projectile_container

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var move_direction:int = 0
var stop_on_slope:bool = true

var jumps:int = 0

func _ready():
	sm.initialize(self)
	PlayerData.call_deferred("set_max_health", max_health)

func initialize(projectile_container):
	self.projectile_container = projectile_container

func _handle_move_input():
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if move_direction < 0:
		body.flip_h = true
		body.offset.x = -50
	elif move_direction > 0:
		body.flip_h = false
		body.offset.x = 50


func _handle_acceleration(multiplier:float = 1.0):
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION * multiplier), -H_SPEED_LIMIT * multiplier, H_SPEED_LIMIT * multiplier)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0

func _handle_cannon_actions(should_fire:bool = true):
	var mouse_position:Vector2 = get_global_mouse_position()
	
	cannon.look_at(mouse_position)
	ray_effect.look_at(mouse_position)
	
	var is_firing = Input.is_action_pressed("fire_cannon") && should_fire
	ray_effect.visible = is_firing
	shield_effect.visible = is_firing
	
	if is_firing:
		var pos:Vector2 = cannon.fire()
		if cannon.did_collide:
			emit_signal("ice", pos.x, pos.y)
		var distance = pos.distance_to(ray_effect.global_position)
		shield_effect.material.set_shader_param("firing_angle", cannon.rotation)
		ray_effect.clamp_distance(distance)
		velocity.x += RECOIL * (1 - int(get_local_mouse_position().x > 0) * 2)
		
	if Input.is_action_pressed("fire_cannon"):
		emit_signal("ice_started")
	elif Input.is_action_just_released("fire_cannon"):
		emit_signal("ice_stopped")
		
	ray_sfx.playing = is_firing

func _apply_movement():
	velocity.y += gravity
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD).y
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func _play_animation(animation_name:String, should_restart:bool = true, playback_speed:float = 1.0, play_backwards:bool = false):
	if player_animation.has_animation(animation_name):
		if should_restart:
			player_animation.stop()
		player_animation.playback_speed = playback_speed
		if play_backwards:
			player_animation.play_backwards(animation_name)
		else:
			player_animation.play(animation_name)

func _is_animation_playing(animation_name:String)->bool:
	return player_animation.current_animation == animation_name && player_animation.is_playing()

func notify_hit(amount):
	state_machine.handle_hit(amount)

func notify_fatal_hit():
	state_machine.handle_fatal_hit()

func _receive_damage(amount):
	if PlayerData.current_health > 0:
		PlayerData.current_health += min(amount, PlayerData.max_health)

func _remove():
	set_physics_process(false)
	hide()
	collision_layer = 0

func is_on_floor()->bool:
	var is_colliding:bool = .is_on_floor()
	if velocity.y >= 0:
		for raycast in floor_raycasts:
			raycast.force_raycast_update()
			is_colliding = is_colliding || raycast.is_colliding()
	return is_colliding


