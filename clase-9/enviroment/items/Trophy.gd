extends Area2D

signal picked()

func _ready():
	connect("body_entered", self, "_on_Trophy_body_entered")

func _on_Trophy_body_entered(body):
	if body is Player:
		emit_signal("picked")
