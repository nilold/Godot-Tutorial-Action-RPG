extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 80
const ROLL_SPEED = 110
const FRICTION = 400

var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

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
		roll_vector = vector
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
