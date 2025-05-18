@tool
extends Node3D

@export var terrain:Terrain3D
@export_tool_button("Snap to terrain") var snap_to_terrain_action=snap_to_terrain

@export var random_scale: Vector2
@export_tool_button("Randomize scale") var randomize_scale_action=randomize_scale

func snap_to_terrain():
	print("Snap to terrain")
	for child in get_children():
		var height = terrain.data.get_height(child.global_position)
		child.global_position.y = height

func randomize_scale():
	for child in get_children():
		var value = randf_range(random_scale.x, random_scale.y)
		child.scale = Vector3.ONE * value
