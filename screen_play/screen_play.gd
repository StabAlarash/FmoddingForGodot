extends Control

@onready var player = $player
@onready var screen_options = $screen_options

func _ready():
	screen_options.paused_changed.connect(_on_paused_changed)

func _on_paused_changed(value):
	player.enabled = not value

#var paused = false
#
#func _input(_event):
	#if Input.is_action_just_pressed("pause_toggle"):
		#paused = not paused
		#get_tree().paused = paused
		#player.enabled = not paused
		#screen_options.visible = paused
