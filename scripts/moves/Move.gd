extends Node
class_name Move

var player : CharacterBody3D
var gravity = 9.8

static var moves_priority : Dictionary = {
	"idle" : 1,
	"run" : 2,
	"sprint" : 3,
	"crouch" : 4,
	"jump": 10
}

static func moves_priority_sort(a: String, b : String):
	if moves_priority[a] > moves_priority[b]:
		return true
	return false

func check_relevance(input : InputPackage) -> String:
	print_debug("error, implement the check_relevance function in the state")
	return "error dumbass"

func update(input : InputPackage, delta : float):
	pass

func on_enter_state():
	pass

func on_exit_state():
	pass
