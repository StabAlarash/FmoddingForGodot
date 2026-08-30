@tool
extends Node3D

@onready var sun = $Sun
@onready var moon = $Moon

@export var speed = 0.1
@export var process_in_editor:bool

@export var time_of_day = 0.0:
	set(value):
		time_of_day = value
		update_time_of_day()

@export var sun_energy:Curve
@export var moon_energy:Curve
@export var sky:ProceduralSkyMaterial
@export var sky_energy:Curve
@export var top_color_gradient:Gradient
@export var horizon_color_gradient:Gradient
@export var bottom_color_gradient:Gradient

func _process(delta):
	if not process_in_editor and Engine.is_editor_hint():
		return
	time_of_day = fmod(time_of_day + delta * speed, 24.0)

func update_time_of_day():
	if not is_inside_tree():
		return
	sun.light_energy = sun_energy.sample(time_of_day)
	moon.light_energy = moon_energy.sample(time_of_day)
	sky.energy_multiplier = sky_energy.sample(time_of_day)
	
	var ratio = time_of_day / 24.0
	var gradient_ratio = 1 - abs(ratio-0.5)*2
	sky.sky_top_color = top_color_gradient.sample(gradient_ratio)
	sky.sky_horizon_color = horizon_color_gradient.sample(gradient_ratio)
	sky.ground_horizon_color = horizon_color_gradient.sample(gradient_ratio)
	sky.ground_bottom_color = bottom_color_gradient.sample(gradient_ratio)
	
	rotation_degrees.x = ratio * 360.0
