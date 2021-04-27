extends Sprite

onready var fire_position = $FirePosition

export (PackedScene) var projectile_scene:PackedScene

var container:Node

func fire():
	var newProjectile = projectile_scene.instance()
	container.add_child(newProjectile)
	newProjectile.initialize((fire_position.global_position - global_position).normalized(), fire_position.global_position)
	
