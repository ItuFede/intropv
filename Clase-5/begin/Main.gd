extends Node

onready var player = $Player

func _ready():
	randomize()
	player.initialize(self)
