extends SpotLight3D

func _ready():
	visible = false
	
func _input(_event):
	if Input.is_action_just_pressed("toggle_light"):
		visible = not visible
