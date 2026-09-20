extends Area3D

func _ready():
	area_entered.connect(_on_body_entered)
	area_exited.connect(_on_body_exited)
	
func _on_body_entered(area: Area3D):
	if not area.is_in_group("player_camera"): return
	print("entered water")
	Globals.underwater = true
	
func _on_body_exited(area: Area3D):
	if not area.is_in_group("player_camera"): return
	print("exited water")
	Globals.underwater = false
