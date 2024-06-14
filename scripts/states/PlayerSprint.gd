extends PlayerState
class_name PlayerSprint


func Enter():
	player.speed = SPRINT_SPEED
	
func Update(_delta: float):
	if !Input.is_action_pressed("sprint"):
		Transitioned.emit(self, "PlayerWalk")
	
	if Input.is_action_pressed("jump") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
	
	if Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "PlayerSlide")
	
	if !player.is_on_floor():
		Transitioned.emit(self, "PlayerMidAir")

func Physics_Update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		Transitioned.emit(self, "PlayerIdle")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
