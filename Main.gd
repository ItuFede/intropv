extends Node

onready var player = $PlayerKinematic
onready var enemy = $Enemy
onready var enemy2 = $Enemy2
onready var enemy3 = $Enemy3

func _ready():
	randomize()
	player.initialize(self)
	
	enemy.initialize(self)
	enemy2.initialize(self)
	enemy3.initialize(self)
	
	enemy.global_position = random_area()
	enemy2.global_position = random_area()
	enemy3.global_position = random_area()
	
func random_area():
	var screen_size = get_viewport().size
	return Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y/2))
