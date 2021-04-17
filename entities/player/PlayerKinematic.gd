extends KinematicBody2D

export (float) var speed:float = 150
export (float) var gravity:float = 5
export (float) var jump:float = 100

func _physics_process(delta):
	var right_pressed:bool = Input.is_action_pressed("derecha")
	var left_pressed:bool = Input.is_action_pressed("izquierda")
	
#	var direction:int = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
#	position.x += direction * speed * delta

	var moveBy = Vector2(0,0)
	if (right_pressed):
		moveBy = Vector2(speed,0)
	if (left_pressed):
		moveBy = Vector2(-speed,0)
	self.move_and_slide(moveBy, Vector2(0,-1))
	
	if(is_on_floor()):
		print("On floor")
	else:
		move_and_collide(Vector2(0,gravity))
	
	
#func _process(delta):
#	var right:bool = Input.is_action_pressed("derecha")
#	var left:bool = Input.is_action_pressed("izquierda")
#
#	var direction:int = int(Input.is_action_pressed("derecha")) - int(Input.is_action_pressed("izquierda"))
#	position.x += direction * speed * delta
