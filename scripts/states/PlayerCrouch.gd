extends PlayerState
class_name PlayerCrouch

func Enter():
	player.speed = CROUCH_SPEED
	player.head.CROUCH_DEPTH = CROUCHING_DEPTH
	player.standing_collision.disabled = true
	player.crouch_collision.disabled = false

func Exit():
	player.standing_collision.disabled = false
	player.crouch_collision.disabled = true
	player.head.CROUCH_DEPTH = 0.0

func Physics_Update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if !Input.is_action_pressed("crouch") and not player.head.head_raycast.is_colliding():
		Transitioned.emit(self, "PlayerIdle")
	
	if !player.is_on_floor():
		Transitioned.emit(self, "PlayerMidAir")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
