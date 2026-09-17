extends RayCast3D

func _physics_process(_delta):
	if not is_colliding():
		Game.interactable = null
		return
		
	var interactable = get_collider()
	if interactable is not Interactable:
		return
	
	Game.interactable = interactable

func _input(_event):
	if Input.is_action_just_pressed("interact") and Game.interactable:
		Game.interactable.interact()
