class_name Context
extends Node

signal finished

func on_enter() -> void:
	pass
	
func on_exit() -> void:
	pass

func finish() -> void:
	finished.emit()
