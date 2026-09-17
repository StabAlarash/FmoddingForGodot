extends Node

signal interactable_changed
var interactable:Interactable:
	set(value):
		interactable = value
		interactable_changed.emit()
