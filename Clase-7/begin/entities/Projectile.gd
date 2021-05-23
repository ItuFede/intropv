extends Node2D

onready var lifetime_timer = $LifetimeTimer
onready var hitbox = $Hitbox
onready var remove_tween = $RemoveTween

export (float) var VELOCITY:float = 800.0
export (int) var damage = 1

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()
	_animate_projectile()

func _physics_process(delta):
	position += direction * VELOCITY * delta

func _on_lifetime_timer_timeout():
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	call_deferred("_remove")

func _remove():
	if remove_tween.is_active():
		return
	set_physics_process(false)
	remove_tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.05)
	remove_tween.start()
	yield(remove_tween, "tween_all_completed")
	get_parent().remove_child(self)
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.has_method("notify_hit"):
		body.notify_hit(-damage)
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	lifetime_timer.stop()
	call_deferred("_remove")


# Stub a implementar por herencia
func _animate_projectile():
	pass
