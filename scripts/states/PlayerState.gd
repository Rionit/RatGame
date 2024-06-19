extends State
class_name PlayerState

@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
@export var CROUCH_SPEED = 2.0
@export var SLIDE_SPEED = 10.0
@export var SENSITIVITY = 0.25
@export var JUMP_VELOCITY = 4.5

const CROUCHING_DEPTH = -0.5

@export var player: CharacterBody3D

var direction = Vector3.ZERO
var gravity = 9.8

func fall_shake():
	if last_state and last_state.name in ["PlayerJump", "PlayerMidAir"]:
		player.head.shake(0.5)

func handle_gravity(delta):
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

func handle_movement(delta, input_dir):
	direction = lerp(direction, (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * 15)
	
	if player.is_on_floor():
		if direction:
			player.velocity.x = direction.x * player.speed
			player.velocity.z = direction.z * player.speed
		else:
			player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * 7.0)
			player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * 7.0)
	else:
		player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * 2.0)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * 2.0)
