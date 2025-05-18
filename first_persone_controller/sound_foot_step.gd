extends FmodEventEmitter3D

@export var raycast:RayCast3D

enum Surface {
	Grass,
	Wood,
	Carpet,
}
var surface:Surface

func _on_headbob_stepped():
	if not raycast.is_colliding():
		return
	var collider = raycast.get_collider()
	#print(collider.name.split("-")[-1])
	
	# Terrain collision
	if collider is Terrain3D:
		var point := raycast.get_collision_point()
		match collider.data.get_control_base_id(point):
			0: surface = Surface.Grass
			1: surface = Surface.Wood
			2: surface = Surface.Carpet
	
	# name based
	else:
		match(collider.name.split("-")[-1]):
			"dirt":
				surface = Surface.Wood
			"grass":
				surface = Surface.Grass
			"gravel":
				surface = Surface.Carpet
				
	set_parameter("Surface", Surface.keys()[surface])
	play()
