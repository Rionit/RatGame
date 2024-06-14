extends PlayerState
class_name PlayerSlide

@onready var slide_timer = $SlideTimer

func Enter():
	player.speed = SLIDE_SPEED
	player.head.CROUCH_DEPTH = CROUCHING_DEPTH
	player.standing_collision.disabled = true
	player.crouch_collision.disabled = false
	slide_timer.start()

func Exit():
	player.standing_collision.disabled = false
	player.crouch_collision.disabled = true
	player.head.CROUCH_DEPTH = 0.0
	slide_timer.stop()

func Physics_Update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("jump"):
		Transitioned.emit(self, "PlayerJump")
	
	if !player.is_on_floor():
		Transitioned.emit(self, "PlayerMidAir")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
	player.velocity.x *= slide_timer.time_left + 0.2
	player.velocity.z *= slide_timer.time_left + 0.2

func _on_slide_timer_timeout():
	if player.head.head_raycast.is_colliding():
		Transitioned.emit(self, "PlayerCrouch")
	else:
		Transitioned.emit(self, "PlayerIdle")
