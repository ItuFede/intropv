extends Sprite

onready var fire_position = $FirePosition

#var projectile_scene:PackedScene = load("res://entities/player/PlayerProjectile.tscn")
export (PackedScene) var projectile_scene:PackedScene

#var container:Node

func fire():
	var new_projectile = projectile_scene.instance()
#	container.add_child(new_projectile)
#	new_projectile.initialize((fire_position.global_position - global_position).normalized(), fire_position.global_position)
