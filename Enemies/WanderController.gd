extends Node2D

onready var timer = $Timer

export(int) var wander_range = 48

onready var start_position = global_position
onready var target_position = global_position

func  update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func start_wander_timer(duration):
	if timer.time_left == 0:
		timer.start(duration)

func _on_Timer_timeout():
	update_target_position()


