extends Node3D

@onready var pivot = $Pivot

var opened:bool



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		opened = true

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		opened = false

func _process(delta):
	var target:float = -PI / 2.0 if opened else 0.0
	pivot.rotation.y = lerp(pivot.rotation.y, target, 4.0*delta)
