extends Move
class_name Crouch

const CROUCH_SPEED = 2.0
const CROUCHING_DEPTH = -0.5

@onready var head_raycast = $"../../HeadRaycast"
@onready var standing_collision = $"../../StandingCollision"
@onready var crouch_collision = $"../../CrouchCollision"
@onready var head = $"../../Head"

func check_relevance(input: InputPackage) -> String:
	if input.actions[0] == "crouch":
		return "okay"
	return input.actions[0]

func update(input: InputPackage, delta: float):
	player.velocity = velocity_by_input(input, delta)
	player.move_and_slide()

func on_enter_state():
	standing_collision.disabled = true
	crouch_collision.disabled = false

func on_exit_state():
	standing_collision.disabled = false
	crouch_collision.disabled = true

func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	var new_velocity = player.velocity

	# Get the input direction and handle the movement/deceleration.
	var direction = (player.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized()
	
	if player.is_on_floor():
		if direction != Vector3.ZERO:
			new_velocity.x = direction.x * CROUCH_SPEED
			new_velocity.z = direction.z * CROUCH_SPEED
		else:
			new_velocity.x = lerp(new_velocity.x, 0, delta * 7.0)
			new_velocity.z = lerp(new_velocity.z, 0, delta * 7.0)
	else:
		new_velocity.x = lerp(new_velocity.x, direction.x * CROUCH_SPEED, delta * 2.0)
		new_velocity.z = lerp(new_velocity.z, direction.z * CROUCH_SPEED, delta * 2.0)

	head.position.y = lerp(head.position.y, 1.8 + CROUCHING_DEPTH, delta * 10)

	return new_velocity
