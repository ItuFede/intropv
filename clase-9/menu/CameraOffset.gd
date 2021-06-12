extends Position2D

const POINTER_LIMIT = 300

onready var camera = $CameraPosition

var target : Vector2 = Vector2.ZERO
var weight = 0.05

func _ready():
	position = get_viewport().get_visible_rect().size / 2

func _process(delta):
	camera.position = lerp(camera.position, target, weight)

func _input(event):
	if event is InputEventMouseMotion:
		_update_target(get_local_mouse_position())

func _update_target(mouse_pos):
	target = mouse_pos.clamped(POINTER_LIMIT)
