extends "res://entities/Projectile.gd"

onready var anim = $RotationAnimation

func _animate_projectile():
	if direction.x >= 0:
		anim.play("rotate")
	else:
		anim.play_backwards("rotate")
