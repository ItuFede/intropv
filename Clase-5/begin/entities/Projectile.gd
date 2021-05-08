extends Sprite

onready var lifetime_timer = $LifetimeTimer
onready var hitbox = $Hitbox
onready var fire_animation = $AnimationFire

export (float) var VELOCITY:float = 800.0

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
#	_play_animation("FireBall")
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _play_animation(animation_name:String):
	if fire_animation.has_animation(animation_name):
		fire_animation.play(animation_name)

func _physics_process(delta):
	position += direction * VELOCITY * delta

func _on_lifetime_timer_timeout():
	call_deferred("_remove")

func _remove():
	get_parent().remove_child(self)
	queue_free()

func _on_Hitbox_body_entered(body):
	if body.has_method("notify_hit"):
		body.notify_hit()
	hitbox.collision_mask = 0
	call_deferred("_remove")

