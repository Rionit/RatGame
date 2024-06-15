extends PlayerState
class_name PlayerJump

func Enter():
	player.velocity.y = JUMP_VELOCITY
	
func Physics_Update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if player.is_on_floor():
		Transitioned.emit(self, last_state.name)
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
