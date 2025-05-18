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
	
	#print(FmodServer.banks_still_loading())
	#var bank:FmodBank = FmodServer.get_all_banks()[0]
	##for bank:FmodBank in FmodServer.get_all_banks():
	#print(bank)
	#for bus:FmodBus in bank.get_bus_list():
		#print(bus)
		#print(bus.get_path())
		#print(bus.get_guid())
		#
	#var bus_music = FmodServer.get_bus_from_guid("{4530a1a8-7731-4e04-ae3b-138c7dd60fa2}")
	#
	##var bus_music:FmodBus = bank.get_bus("bus:/Music")
	#print(bus_music, " ", bus_music.get_path())
	#bus_music.volume = 5
	#for bank:FmodBank in FmodServer.get_all_banks():
		#print(bank.get_path())
		#for bus:FmodBus in bank.get_bus_list():
			#print(bus.get_path())

	#for bus:FmodBus in FmodServer.get_all_buses():
		#print(bus.get_path())

func _on_master_changed(value:float):
	master_bus.volume = value
	
func _on_music_changed(value:float):
	music_bus.volume = value
	
func _on_sfx_changed(value:float):
	sfx_bus.volume = value

func _input(_event):
	if Input.is_action_just_pressed("pause_toggle"):
		paused = not paused

func _on_btn_back_title_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://screen_title/screen_title.tscn")

func _on_btn_continue_pressed():
	paused = false
