extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn") # load just once at the start and then reuse whener we need
		
func _on_HurtBox_area_entered(_area: Area2D):
	load_grass_effect()
	queue_free()

func load_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
