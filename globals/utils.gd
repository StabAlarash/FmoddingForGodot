extends Node


func get_surface_from_collider(
	collider:CollisionObject3D,
	default:String = "Grass",
) -> String:
	if collider.has_meta("surface"):
		return collider.get_meta("surface")

	var parent = collider.get_parent()
	if parent == null:
		return default
		
	if parent.has_meta("surface"):
		return parent.get_meta("surface")
	
	if parent.has_meta("extras"):
		var extra:Dictionary = parent.get_meta("extras")
		if extra.has("surface"):
			return extra["surface"]
	
	return default
