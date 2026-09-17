extends Node

signal time_changed
var time:float = 0.0:
	set(value):
		time = value
		time_changed.emit()

signal zone_changed
var zone: String:
	set(value):
		zone = value
		zone_changed.emit()
		FmodServer.set_global_parameter_by_name_with_label("Zone", zone)

signal subzone_changed
var subzone: String:
	set(value):
		subzone = value
		subzone_changed.emit()
		#FmodServer.set_global_parameter_by_name_with_label("Zone", zone)

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
