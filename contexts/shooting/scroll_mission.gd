extends Node3D

@export var context_scene:PackedScene


func _on_interactable_interacted():
	var context = context_scene.instantiate()
	Game.context_requested.emit(context)
