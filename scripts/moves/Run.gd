extends Move
class_name Run

const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0

var speed: float = WALK_SPEED
var direction = Vector3.ZERO

func check_relevance(input: InputPackage) -> String:
	input.actions.sort_custom(moves_priority_sort)
	if input.actions[0] == "run":
		return "okay"
	return input.actions[0]

func update(input: InputPackage, delta: float):
	handle_input(input)
	player.velocity = velocity_by_input(input, delta)
	player.move_and_slide()

func handle_input(input: InputPackage):
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

func velocity_by_input(input: InputPackage, delta: float) -> Vector3:
	var new_velocity = player.velocity

	# Get the input direction and handle the movement/deceleration.
	direction = lerp(direction, (player.transform.basis * Vector3(input.input_direction.x, 0, input.input_direction.y)).normalized(), delta * 15)
	
	if player.is_on_floor():
		if direction != Vector3.ZERO:
			new_velocity.x = direction.x * speed
			new_velocity.z = direction.z * speed
		else:
			new_velocity.x = lerp(new_velocity.x, 0, delta * 7.0)
			new_velocity.z = lerp(new_velocity.z, 0, delta * 7.0)
	else:
		new_velocity.x = lerp(new_velocity.x, direction.x * speed, delta * 2.0)
		new_velocity.z = lerp(new_velocity.z, direction.z * speed, delta * 2.0)
	
	return new_velocity
