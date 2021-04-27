extends KinematicBody2D

onready var arm = $Player/Arm
export (float) var speed:float = 150
export (float) var gravity:float = 5
export (float) var jump:float = 100
export (float) var friction:float = 0.1
export (float) var acceleration:float = 0.5

var velocity = Vector2.ZERO

func initialize(projectile_container):
	arm.container = projectile_container

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func get_input():
	var mouse_position:Vector2 = get_local_mouse_position()
	arm.rotation = mouse_position.normalized().angle()
	
	var right_pressed:bool = Input.is_action_pressed("derecha")
	var left_pressed:bool = Input.is_action_pressed("izquierda")
	
	var dir = 0
	if right_pressed:
		dir += 1
	if left_pressed:
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	if Input.is_action_just_pressed("right_click"):
		arm.fire()
	
	if(is_on_floor()):
#		print("On floor")
		pass
	else:
		move_and_collide(Vector2(0,gravity))
	
