extends Node3D

@export var fpscharacter:FPSCharacter
@onready var fmod_event_emitter = $FmodEventEmitter3D
@onready var ray_cast:RayCast3D = $RayCast3D

var timer:float = 0.0

func _process(delta):
	if fpscharacter.moving and fpscharacter.was_on_floor:
		timer += delta * fpscharacter.speed
		if timer > 2.0:
			timer -= 2.0
			step()
	else:
		timer = 0.0
	
	if ray_cast.is_colliding():
		var collider:CollisionObject3D = ray_cast.get_collider()
		var surface = "Grass"  # default
		if collider.has_meta("surface"):
			surface = collider.get_meta("surface")
		else:
			var parent = collider.get_parent()
			if parent:
				if parent.has_meta("surface"):
					surface = parent.get_meta("surface")
				elif parent.has_meta("extras"):
					var extra:Dictionary = parent.get_meta("extras")
					if extra.has("surface"):
						surface = extra["surface"]
					
		#print(surface)
		fmod_event_emitter.set_parameter("Surface", surface)
		Globals.surface = surface
		
func step():
	fmod_event_emitter.play()
