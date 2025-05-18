extends Area3D
class_name FPSInteractable

signal entered
signal exited
signal hovered
signal interacted

func on_enter():
	entered.emit()
	
func on_exit():
	exited.emit()
	
func on_hover():
	hovered.emit()

func on_interact():
	interacted.emit()
