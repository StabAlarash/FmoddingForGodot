@tool
extends Node3D

@onready var animation = $AnimationPlayer

@export var offset = 0.0:
	set(value):
		if not animation:
			await ready
		offset = value
		animation.seek(offset)
		

@export_range(1.0, 3600.0) var day_length = 1.0:
	set(value):
		if not animation:
			await ready
		day_length = value
		animation.speed_scale = 1.0 / day_length
