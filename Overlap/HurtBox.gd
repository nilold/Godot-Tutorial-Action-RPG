extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invicicle

signal invicibility_started
signal invicibility_ended

func set_invicicle(value):
	invincible = value
	if invincible:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")

func hit(invisibility_duration):
	start_invincibility(invisibility_duration)
	create_hit_effect()

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	hitEffect.position = position
	get_parent().add_child(hitEffect)


func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_invicibility_started():
	set_deferred("monitorable", false)


func _on_HurtBox_invicibility_ended():
	set_deferred("monitorable", true)
