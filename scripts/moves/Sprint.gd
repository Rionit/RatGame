extends Move
class_name Sprint

const SPRINT_SPEED = 8.0
var direction = Vector3.ZERO

@onready var standing_collision = $"../../StandingCollision"
@onready var crouch_collision = $"../../CrouchCollision"
@onready var head_raycast = $"../../HeadRaycast"
@onready var head = $"../../Head"

func check_relevance(input : InputPackage):
	input.actions.sort_custom(moves_priority_sort)
	if input.actions[0] == "run":
		return "okay"
	return input.actions[0]

func update(input : InputPackage, delta : float):
	player.velocity = velocity_by_input(input, delta)
	player.move_and_slide()

func velocity_by_input(input : InputPackage, delta : float) -> Vector3:
	var new_velocity = player.velocity

	# Get the input direction and handle the movement/deceleration.
	direction = lerp(direction, (player.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized(), delta * 15)
	
	if player.is_on_floor():
		if direction:
			new_velocity.x = direction.x * SPRINT_SPEED
			new_velocity.z = direction.z * SPRINT_SPEED
		else:
			new_velocity.x = lerp(new_velocity.x, direction.x * SPRINT_SPEED, delta * 7.0)
			new_velocity.z = lerp(new_velocity.z, direction.z * SPRINT_SPEED, delta * 7.0)
	else:
		new_velocity.x = lerp(new_velocity.x, direction.x * SPRINT_SPEED, delta * 2.0)
		new_velocity.z = lerp(new_velocity.z, direction.z * SPRINT_SPEED, delta * 2.0)
	
	return new_velocity
	
