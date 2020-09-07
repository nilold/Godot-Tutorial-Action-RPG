extends KinematicBody2D

const BatDeathffect = preload("res://Effects/BatDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200


enum {
	WANDER,
	CHASE
}

var state = WANDER

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtBox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $BlinkAnimation

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		WANDER:
			wander(delta)
			seek_player()
		CHASE:
			chase_player(delta)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector()
	
	velocity = move_and_slide(velocity)

func wander(delta):
	accelearate_towards(wanderController.target_position, delta)
	wanderController.start_wander_timer(5)

func chase_player(delta):
	var player = playerDetectionZone.player
	if player:
		accelearate_towards(player.global_position, delta)
	else:
		state= WANDER
			
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	else:
		state = WANDER
		
func accelearate_towards(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func _on_HurtBox_area_entered(area: Area2D):
	stats.health -= area.damage
	knockback = area.knockback_vector
	velocity = move_and_slide(knockback)
	hurtBox.hit(0.3)

func _on_Stats_no_health():
	queue_free()
	var batDeathEffect = BatDeathffect.instance()
	batDeathEffect.position = position
	get_parent().add_child(batDeathEffect)

func _on_HurtBox_invicibility_started():
	animationPlayer.play("Start")
	
func _on_HurtBox_invicibility_ended():
	animationPlayer.play("Stop")
