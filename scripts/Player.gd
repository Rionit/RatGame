extends CharacterBody3D

@export var SENSITIVITY = 0.25
@export var SPRINT_SPEED = 8.0

@onready var head = $Head
@onready var standing_collision = $StandingCollision
@onready var crouch_collision = $CrouchCollision

var speed = 0.0
var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	handle_mouse_input(event)

func _physics_process(delta):
	head.update(velocity, delta)
	
	Global.debug.add_property("Velocity", snapped(velocity.length(), 0.01), 2)
	
	move_and_slide()

func handle_mouse_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

