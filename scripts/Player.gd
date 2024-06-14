extends CharacterBody3D

@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
@export var CROUCH_SPEED = 2.0
@export var SLIDE_SPEED = 10.0
@export var SENSITIVITY = 0.25
@export var JUMP_VELOCITY = 4.5

const CROUCHING_DEPTH = -0.5

var speed
var direction = Vector3.ZERO
var gravity = 9.8

var sliding = false
var slide_direction = Vector2.ZERO

@onready var head = $Head
@onready var standing_collision = $StandingCollision
@onready var crouch_collision = $CrouchCollision
@onready var head_raycast = $HeadRaycast
@onready var slide_timer = $SlideTimer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	handle_mouse_input(event)

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_crouch(delta)
	handle_sliding()
	handle_movement(delta)
	
	head.update(velocity, delta)
	
	move_and_slide()

func handle_mouse_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_crouch(delta):
	if Input.is_action_pressed("crouch") or sliding:
		standing_collision.disabled = true
		crouch_collision.disabled = false
		
		speed = CROUCH_SPEED
		head.position.y = lerp(head.position.y, 1.8 + CROUCHING_DEPTH, delta * 10)
		
		if velocity.length() > WALK_SPEED and Input.get_vector("left", "right", "up", "down") != Vector2.ZERO and not sliding:
			slide_timer.start()
			slide_direction = Input.get_vector("left", "right", "up", "down")
			sliding = true
			
	elif not head_raycast.is_colliding():
		standing_collision.disabled = false
		crouch_collision.disabled = true
		
		head.position.y = lerp(head.position.y, 1.8, delta * 10)
		speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else WALK_SPEED

func handle_sliding():
	if sliding:
		direction = (transform.basis * Vector3(slide_direction.x, 0, slide_direction.y)).normalized()
		speed = SLIDE_SPEED
		if slide_timer.time_left == 0:
			sliding = false
			speed = CROUCH_SPEED

func handle_movement(delta):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * 15)
	
	if is_on_floor():
		if direction:
			var factor = 1.0 if slide_timer.time_left == 0 else (slide_timer.time_left + 0.2)
			velocity.x = direction.x * speed * factor
			velocity.z = direction.z * speed * factor
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

func _on_slide_timer_timeout():
	sliding = false
	speed = CROUCH_SPEED
