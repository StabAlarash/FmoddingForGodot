class_name State extends Node

var state_machine:StateMachine
var root:Node:
	get():
		if state_machine:
			return state_machine.root
		return null

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

func on_process(_delta:float) -> void:
	pass
 
func on_physic_process(_delta:float) -> void:
	pass
