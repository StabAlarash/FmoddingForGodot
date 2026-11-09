extends Node

@onready var screen_options = $screen_options
@onready var character = $Character

@onready var lbl_interactable = %lbl_interactable

@export var context:Context

func _ready():
	screen_options.paused_changed.connect(_on_pause_changed)
	Game.interactable_changed.connect(_on_interactable_changed)
	Game.context_requested.connect(set_context)
	
	if context:
		set_context(context)
	
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
		lbl_interactable.text = "[E] " + interactable.text
	else:
		lbl_interactable.text = ""

func set_context(c) -> void:
	if context != null and context != c:
		context.on_exit()
		context = null
	context = c
	if context:
		add_child(context)
		context.on_enter()
		context.finished.connect(_on_context_finished)
		
func _on_context_finished():
	set_context(null)
