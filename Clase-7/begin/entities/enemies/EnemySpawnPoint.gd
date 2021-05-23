extends Node2D
class_name EnemySpawnPoint

export (PackedScene) var enemy_scene

func spawn(pathfind):
	var enemy_instance = enemy_scene.instance()
	enemy_instance.initialize(self, global_position, self, pathfind)
