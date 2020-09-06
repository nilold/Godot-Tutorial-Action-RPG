extends Node2D
		
func _on_HurtBox_area_entered(area: Area2D):
	load_grass_effect()
	queue_free()

func load_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	var world = get_tree().current_scene
	world.add_child(grassEffect)
