extends KinematicBody2D

onready var fire_position = $FirePosition
onready var raycast = $FirePosition/RayCast2D
onready var remove_anim_player = $RemoveAnimPlayer

onready var body_sprite:AnimatedSprite = $Body

onready var state_machine = $StateMachine

export (PackedScene) var projectile_scene

var target
var projectile_container

var velocity:Vector2

var navigation:PathfindA

var health:int = 5

func initialize(container, turret_pos, projectile_container, pathfind=null):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container
	navigation = pathfind
	state_machine.set_parent(self)

func _apply_movement():
	velocity.y += 20
	velocity = move_and_slide(velocity)

func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))

func notify_hit(amount):
	state_machine.notify_hit(amount)
	

func _remove():
	get_parent().remove_child(self)
	queue_free()

func can_see_target()->bool:
	if target == null:
		return false
	raycast.set_cast_to(to_local(target.global_position))
	return raycast.is_colliding() && raycast.get_collider() == target

func _play_animation(animation_name:String):
	if body_sprite.frames.has_animation(animation_name):
		body_sprite.play(animation_name)


func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body

func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null

func _on_Body_animation_finished():
	state_machine._on_animation_finished(body_sprite.animation)

