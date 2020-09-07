extends Node2D


export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(new_healt)
signal max_health_changed(new_max_healt)

func set_max_health(value):
	max_health = max(value, 1)
	health = min(self.health, value)
	emit_signal("max_health_changed", value)

func set_health(value):
	health = min(value, max_health)
	emit_signal("health_changed",  health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
