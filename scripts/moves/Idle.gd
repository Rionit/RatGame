extends Move
class_name Idle

func check_relevance(input) -> String:
	input.actions.sort_custom(moves_priority_sort)
	return input.actions[0]
	
func update(input: InputPackage, delta: float):
	player.velocity = Vector3.ZERO
	player.move_and_slide()
