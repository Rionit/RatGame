extends RigidBody3D

var health = 20

func hit_successful(damage, _direction:= Vector3.ZERO, _position:= Vector3.ZERO):
	var hit_position = _position - get_global_transform().origin
	
	health -= damage
	
	print("Health: " + str(health))
	if health <= 0:
		queue_free()
	
	if _direction != Vector3.ZERO:
		apply_impulse((_direction*damage), hit_position)
