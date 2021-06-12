extends Node

signal max_health_updated(amount, current_health)
signal health_updated(amount, max_health)

var max_health:int
var current_health:int setget set_current_health

func set_max_health(amount:int)->void:
	max_health = amount
	current_health = max_health
	emit_signal("max_health_updated", max_health, current_health)

func set_current_health(amount:int)->void:
	current_health = amount
	emit_signal("health_updated", current_health, max_health)
