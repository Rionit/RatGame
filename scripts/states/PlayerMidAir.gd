extends PlayerState
class_name PlayerMidAir

	
func physics_update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if player.is_on_floor():
		transitioned.emit(self, "PlayerIdle")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
