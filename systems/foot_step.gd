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
		var surface = Utils.get_surface_from_collider(collider)
					
		fmod_event_emitter.set_parameter("Surface", surface)
		Globals.surface = surface
		
func step():
	fmod_event_emitter.play()
