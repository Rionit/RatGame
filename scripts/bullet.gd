extends RigidBody3D

var damage : int = 0

func _on_body_entered(body):
	if body.is_in_group("Target") and body.has_method("hit_successful"):
		body.hit_successful(damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
