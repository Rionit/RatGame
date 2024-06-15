extends PlayerState
class_name PlayerSlide

@onready var slide_timer = $SlideTimer

func enter():
	player.speed = SLIDE_SPEED
	player.head.CROUCH_DEPTH = CROUCHING_DEPTH
	player.standing_collision.disabled = true
	player.crouch_collision.disabled = false
	slide_timer.start()

func exit():
	player.standing_collision.disabled = false
	player.crouch_collision.disabled = true
	player.head.CROUCH_DEPTH = 0.0
	slide_timer.stop()

func physics_update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("jump"):
		transitioned.emit(self, "PlayerJump")
	
	if !player.is_on_floor():
		transitioned.emit(self, "PlayerMidAir")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
	player.velocity.x *= slide_timer.time_left + 0.2
	player.velocity.z *= slide_timer.time_left + 0.2

func _on_slide_timer_timeout():
	if player.head.head_raycast.is_colliding():
		transitioned.emit(self, "PlayerCrouch")
	else:
		transitioned.emit(self, "PlayerIdle")
