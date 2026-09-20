extends Node3D

@onready var pivot = $Pivot
@onready var interactable = %Interactable

@onready var door_open = %DoorOpen
@onready var door_close = %DoorClose

var opened:bool

func _process(delta):
	var target:float = -PI / 2.0 if opened else 0.0
	pivot.rotation.y = lerp(pivot.rotation.y, target, 4.0*delta)

func _on_interactable_interacted():
	opened = not opened
	if opened:
		interactable.text = "Close"
		door_open.play()
	else:
		interactable.text = "Open"
		door_close.play()
