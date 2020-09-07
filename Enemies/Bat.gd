extends KinematicBody2D

const BatDeathffect = preload("res://Effects/BatDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200


enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)	
			else:
				state= IDLE
			sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector()
	velocity = move_and_slide(velocity)
				
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100
	hurtBox.hit(0.1)

func _on_Stats_no_health():
	queue_free()
	var batDeathEffect = BatDeathffect.instance()
	batDeathEffect.position = position
	get_parent().add_child(batDeathEffect)
