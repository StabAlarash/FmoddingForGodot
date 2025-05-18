extends Node

@export var controller:FPSController
@export var camera:Camera3D

@export var headbob = 0.06
@export var speed = 4.0
@export var damping = 3.0

var move_phase := 0.0

signal stepped
var has_stepped = false

func _physics_process(delta):	
	if controller.speed and controller.is_on_floor():
		move_phase = fmod(move_phase + controller.speed * speed * delta, 2*PI) 
		camera.position.y = abs(sin(move_phase)) * headbob
		if (
			camera.position.y < 0.01 and 
			controller.is_on_floor() and
			not has_stepped
		):
			has_stepped = true
			stepped.emit()
			#sound_foot_step.pitch_scale = randf_range(0.5, 0.8)
			#sound_foot_step.play()
			
		if camera.position.y > 0.01:
			has_stepped = false
		
	else:
		move_phase = 0.0
		camera.position.y = lerp(camera.position.y, 0.0, damping * delta)
		has_stepped = false
