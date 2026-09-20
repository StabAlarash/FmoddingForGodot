extends Node

@onready var screen_options = $screen_options
@onready var character = $Character

@onready var lbl_interactable = %lbl_interactable


func _ready():
	screen_options.paused_changed.connect(_on_pause_changed)
	Game.interactable_changed.connect(_on_interactable_changed)
	
func _on_pause_changed(paused:bool):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED

func _input(_event):
	if Input.is_key_pressed(KEY_2):
		Globals.tension = 1.0
	elif Input.is_key_pressed(KEY_1):
		Globals.tension = 0.0

func _on_interactable_changed():
	var interactable:Interactable = Game.interactable
	if interactable:
		lbl_interactable.text = interactable.text
	else:
		lbl_interactable.text = ""
