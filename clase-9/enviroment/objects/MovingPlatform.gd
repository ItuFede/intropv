extends Node2D

const IDLE_DURATION:float = 1.0

export (Vector2) var move_to = Vector2.UP * 192
export (float) var speed = 300.0

onready var platform = $Platform
onready var tween = $Tween

var follow:Vector2 = Vector2.ZERO

func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)


func _on_PlayerDetectionArea_body_entered(body):
	if body is Player:
		body.stop_on_slope = false


func _on_PlayerDetectionArea_body_exited(body):
	if body is Player:
		body.stop_on_slope = true
