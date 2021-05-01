extends Sprite

onready var cannon_tip = $CannonTip

export (PackedScene) var projectile_scene:PackedScene

var projectile_container

func fire():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, cannon_tip.global_position, global_position.direction_to(cannon_tip.global_position))
