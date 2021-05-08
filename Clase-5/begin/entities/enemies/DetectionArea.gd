extends Area2D
onready var green_circle := $green_circle

func _ready():
	green_circle.modulate = Color("4dffffff")
	green_circle.visible = false
	

func _input(event):
	if event.is_action_pressed("show_detection_area_turret"):
		green_circle.visible = !green_circle.visible
		
