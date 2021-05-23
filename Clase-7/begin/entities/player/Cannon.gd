extends Sprite

onready var cannon_tip = $CannonTip

export (PackedScene) var projectile_scene:PackedScene

var projectile_container
var proj_instance 

func fire():
	proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, cannon_tip.global_position, global_position.direction_to(cannon_tip.global_position))


func add_collision_exception_to_projectile(object):
	proj_instance.add_collision_exception_to_projectile(object)
