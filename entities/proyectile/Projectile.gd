extends Node2D

onready var timer = $DeleteTimer

export (float) var speed

var direction:Vector2

func initialize(fire_direction:Vector2, initial_position:Vector2):
	global_position = initial_position
	direction = fire_direction
	timer.connect("timeout", self, "_on_DeleteTimer_timeout")
	timer.start()
	
func _physics_process(delta):
	position += direction * speed * delta


func _on_DeleteTimer_timeout():
	get_parent().remove_child(self)
	queue_free()
