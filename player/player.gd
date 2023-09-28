extends CharacterBody3D

const SPEED = 5.0
const ROTATION_SPEED = 1.5  # Adjust the rotation speed as needed
const JUMP_VELOCITY = 5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var rotation = transform.basis.get_euler()

	if Input.is_action_pressed("ui_right"):
		rotation.y -= ROTATION_SPEED * delta
	elif Input.is_action_pressed("ui_left"):
		rotation.y += ROTATION_SPEED * delta

	transform.basis = Basis().rotated(Vector3(0, 1, 0), rotation.y)

	var input_forward = Input.is_action_pressed("ui_up")
	var input_backward = Input.is_action_pressed("ui_down")

	# Initialize velocity to zero
	var move_velocity = Vector3.ZERO

	if input_forward and !input_backward:
		move_velocity = -transform.basis.z.normalized() * SPEED
	elif input_backward and !input_forward:
		move_velocity = transform.basis.z.normalized() * SPEED

	# Apply the movement velocity while keeping the vertical velocity (jump/gravity)
	velocity.x = move_velocity.x
	velocity.z = move_velocity.z

	move_and_slide()
