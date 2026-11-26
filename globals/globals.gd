extends Node

signal time_changed
var time:float = 0.0:
	set(value):
		time = value
		time_changed.emit()
		FmodServer.set_global_parameter_by_name("Time", time)

signal zone_changed
var zone: String:
	set(value):
		zone = value
		zone_changed.emit()
		FmodServer.set_global_parameter_by_name_with_label("Zone", zone)

signal subzone_changed
var subzone: String = "None":
	set(value):
		subzone = value
		subzone_changed.emit()
		FmodServer.set_global_parameter_by_name_with_label("SubZone", subzone)

signal tension_changed
var tension:float = 0.0:
	set(value):
		tension = value
		FmodServer.set_global_parameter_by_name("Tension", tension)
		tension_changed.emit()

signal surface_changed
var surface:String:
	set(value):
		if value == surface:
			return
		surface = value
		surface_changed.emit()

signal underwater_changed
var underwater:bool:
	set(value):
		underwater = value
		underwater_changed.emit()
		FmodServer.set_global_parameter_by_name("Underwater", underwater)
		
#region gui_sound
@onready var button_enter = $ButtonEnter
@onready var button_exit = $ButtonExit
@onready var button_pressed = $ButtonPressed
@onready var button_released = $ButtonReleased

func gui_button_enter() -> void:
	button_enter.play()

func gui_button_exit() -> void:
	button_exit.play()
	
func gui_button_pressed() -> void:
	button_pressed.play()
	
func gui_button_released() -> void:
	button_released.play()
	
func setup_gui_button(control:Control) -> void:
	control.mouse_entered.connect(gui_button_enter)
	control.mouse_exited.connect(gui_button_exit)
	if control is Button:
		control.button_down.connect(gui_button_pressed)
		control.button_up.connect(gui_button_released)
	elif control is Slider:
		control.drag_started.connect(gui_button_pressed)
		control.drag_ended.connect(gui_button_released.unbind(1))
#endregion
