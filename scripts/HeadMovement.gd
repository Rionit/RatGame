extends Node3D
class_name HeadMovement

@onready var head_raycast = $"../HeadRaycast"
@onready var camera = $ShakeableCamera.camera
@onready var player = $".."

var t_bob = 0.0

@export var BASE_FOV = 75.0
@export var FOV_CHANGE = 1.5
@export var TILT_ANGLE = 5.0
@export var BOB_FREQ = 2.0
@export var BOB_AMP = 0.08
@export var CROUCH_DEPTH = 0.0

func update(velocity, delta):
	position.y = lerp(position.y, 1.8 + CROUCH_DEPTH, delta * 10)
	update_headbob(velocity, delta)
	update_fov(velocity, delta)
	update_tilt(delta)

func update_headbob(velocity, delta):
	t_bob += delta * velocity.length() * float(player.is_on_floor())
	camera.transform.origin = _headbob(t_bob)

func update_fov(velocity, delta):
	var velocity_clamped = clamp(velocity.length(), 0.5, player.SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func update_tilt(delta):
	var heading = Input.get_axis("left", "right")
	if heading > 0:
		camera.rotation.z = lerp_angle(camera.rotation.z, deg_to_rad(-TILT_ANGLE), delta * 2)
	elif heading < 0:
		camera.rotation.z = lerp_angle(camera.rotation.z, deg_to_rad(TILT_ANGLE), delta * 2)
	else:
		camera.rotation.z = lerp_angle(camera.rotation.z, 0.0, delta * 4)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func shake(amount):
	$ShakeableCamera.add_trauma(amount)
