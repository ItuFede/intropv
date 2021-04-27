extends Sprite

onready var enemyFirePosition = $EnemyFirePosition

export (PackedScene) var projectile_scene:PackedScene

var container:Node
var player

func initialize(projectile_container):
	self.container = projectile_container
	player = projectile_container.player

func _on_TimerShoot_timeout():
	fire()

func fire():
	var newProjectile = projectile_scene.instance()
	self.container.add_child(newProjectile)
	newProjectile.initialize((player.global_position - global_position).normalized(), enemyFirePosition.global_position)
