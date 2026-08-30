extends Node

signal zone_changed
var zone:
	set(value):
		zone = value
		zone_changed.emit()

signal tension_changed
var tension:float = 0.0:
	set(value):
		tension = value
		FmodServer.set_global_parameter_by_name("Tension", tension)
		tension_changed.emit()
