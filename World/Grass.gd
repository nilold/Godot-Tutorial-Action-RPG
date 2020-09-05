extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		load_grass_effect()
		queue_free()
		
func load_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	grassEffect.global_position = global_position
	var world = get_tree().current_scene
	world.add_child(grassEffect)
