extends AnimatedSprite

func _ready():
	var _err = connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")


func _on_animation_finished():
	queue_free()
