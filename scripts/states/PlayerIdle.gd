extends PlayerState
class_name PlayerIdle

func enter():
	player.speed = 0.0
	if last_state and last_state.name in ["PlayerJump", "PlayerMidAir"]:
		player.head.shake(0.5)
	
func update(_delta):
	if Input.is_action_pressed("crouch"):
		transitioned.emit(self, "PlayerCrouch")
	
	if Input.is_action_pressed("jump") and player.is_on_floor():
		transitioned.emit(self, "PlayerJump")

func physics_update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		transitioned.emit(self, "PlayerWalk")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
