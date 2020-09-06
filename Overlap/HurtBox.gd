extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

export(bool) var show_hit = true

func _on_HurtBox_area_entered(area):
	if show_hit:
		var hitEffect = HitEffect.instance()
		hitEffect.position = position
		get_parent().add_child(hitEffect)
