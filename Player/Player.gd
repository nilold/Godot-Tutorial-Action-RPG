extends KinematicBody2D

export var ACCELERATION = 600
export var MAX_SPEED = 80
export var ROLL_SPEED = 110
export var FRICTION = 400

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtBox = $HurtBox
onready var animationState = animationTree.get("parameters/playback")
var stats = PlayerStats

func _ready():
	stats.connect("no_health", self, "queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move(delta)
		ROLL:
			roll(delta)
		ATTACK:
			attack(delta)


func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	roll_vector = input_vector
	swordHitbox.knockback_vector = input_vector
	animate(input_vector)
	velocity = calc_velocity(input_vector, delta)
	apply_velocity()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL;

func roll(delta):
	velocity = roll_vector * ROLL_SPEED
	apply_velocity()
	animationState.travel("Roll")

func attack(delta):
	velocity *= 0.8
	animationState.travel("Attack")
	
func apply_velocity():
	velocity = move_and_slide(velocity)

func calc_velocity(vector, delta):
	if vector != Vector2.ZERO:
		return velocity.move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	else:
		return velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func animate(vector):
	if vector != Vector2.ZERO:

		animationTree.set("parameters/Idle/blend_position", vector)
		animationTree.set("parameters/Run/blend_position", vector)
		animationTree.set("parameters/Attack/blend_position", vector)
		animationTree.set("parameters/Roll/blend_position", vector)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HurtBox_area_entered(area):
	stats.health -= 1
	hurtBox.hit(0.75)
