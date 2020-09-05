extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED = 80
const FRICTION = 400

var velocity = Vector2.ZERO

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

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK;

func roll(delta):
	pass

func attack(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func animate(vector):
	if vector != Vector2.ZERO:
		animationState.travel("Run")
		animationTree.set("parameters/Idle/blend_position", vector)
		animationTree.set("parameters/Run/blend_position", vector)
		animationTree.set("parameters/Attack/blend_position", vector)
	else:
		animationState.travel("Idle")

func attack_animation_finished():
	state = MOVE
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
