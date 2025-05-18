extends RayCast3D

var interactable:FPSInteractable

func _physics_process(delta):
	if is_colliding() and get_collider() is FPSInteractable:
		var collider:FPSInteractable = get_collider()
		if interactable != collider:
			if interactable:
				interactable.on_exit()
				interactable = null
			
			interactable = collider
			interactable.on_enter()
		
		if interactable:
			interactable.on_hover()
	
	else:
		if interactable:
			interactable.on_exit()
			interactable = null
	
	if Input.is_action_just_pressed("interact"):
		if interactable:
			interactable.on_interact()
