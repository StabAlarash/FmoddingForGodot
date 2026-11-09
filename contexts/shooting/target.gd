extends StaticBody3D

signal killed
@onready var target_hit = %TargetHit

func on_arrow_hit(hit: Vector3, velocity: Vector3) -> void:
	killed.emit()
	target_hit.play()
	hide()
	
	await get_tree().create_timer(1).timeout
	
	queue_free()
	
