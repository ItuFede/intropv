extends Node

onready var player = $Player
onready var turret_spawner = $TurretsSpawner

func _ready():
	randomize()
	player.initialize(self)
	turret_spawner.initialize(player)
