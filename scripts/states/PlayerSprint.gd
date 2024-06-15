extends PlayerState
class_name PlayerSprint


func enter():
	player.speed = SPRINT_SPEED
	
func update(_delta: float):
	if !Input.is_action_pressed("sprint"):
		transitioned.emit(self, "PlayerWalk")
	
	if Input.is_action_pressed("jump") and player.is_on_floor():
		transitioned.emit(self, "PlayerJump")
	
	if Input.is_action_pressed("crouch"):
		transitioned.emit(self, "PlayerSlide")
	
	if !player.is_on_floor():
		transitioned.emit(self, "PlayerMidAir")

func physics_update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		transitioned.emit(self, "PlayerIdle")
	
	handle_gravity(_delta)
	handle_movement(_delta, input_dir)
