class_name Interactable
extends Area3D

signal interacted

@export var text:String

func interact() -> void:
	interacted.emit()
