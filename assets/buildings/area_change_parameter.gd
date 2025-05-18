extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "player":
		print("Player entered")
		FmodServer.set_global_parameter_by_name("Tension", 1.0)

func _on_body_exited(body: Node3D) -> void:
	if body.name == "player":
		print("Player exited")
		FmodServer.set_global_parameter_by_name("Tension", 0.0)
