extends CanvasLayer

@export var master_guid: String
@export var music_guid: String
@export var sfx_guid: String

@onready var master_bus = FmodServer.get_bus_from_guid(master_guid)
@onready var music_bus = FmodServer.get_bus_from_guid(music_guid)
@onready var sfx_bus = FmodServer.get_bus_from_guid(sfx_guid)

@onready var slider_master = %slider_master
@onready var slider_sfx = %slider_sfx
@onready var slider_music = %slider_music

@onready var buttons = [
	slider_master,
	slider_sfx,
	slider_music,
	%btn_back_title,
	%btn_continue
]

var paused = false:
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused
		paused_changed.emit(paused)

signal paused_changed(bool)

func _ready():
	slider_master.value_changed.connect(_on_master_changed)
	slider_music.value_changed.connect(_on_music_changed)
	slider_sfx.value_changed.connect(_on_sfx_changed)
	
	for button in buttons:
		Globals.setup_gui_button(button)

func _on_master_changed(value:float):
	master_bus.volume = value
	
func _on_music_changed(value:float):
	music_bus.volume = value
	
func _on_sfx_changed(value:float):
	sfx_bus.volume = value
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		paused = not paused

func _on_btn_back_title_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://screens/title/screen_title.tscn")

func _on_btn_continue_pressed():
	paused = false
