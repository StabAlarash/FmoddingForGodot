extends Control

@onready var lbl_time_value = %lbl_time_value
@onready var lbl_zone_value = %lbl_zone_value
@onready var lbl_subzone_value = %lbl_subzone_value
@onready var lbl_tension_value = %lbl_tension_value
@onready var lbl_surface_value = %lbl_surface_value
@onready var lbl_underwater_value = %lbl_underwater_value

func _ready():
	Globals.time_changed.connect(_on_time_changed)
	Globals.zone_changed.connect(_on_zone_changed)
	Globals.subzone_changed.connect(_on_subzone_changed)
	Globals.tension_changed.connect(_on_tension_changed)
	Globals.surface_changed.connect(_on_surface_changed)
	Globals.underwater_changed.connect(_on_underwater_changed)
	_on_zone_changed()
	_on_subzone_changed()
	_on_tension_changed()
	_on_underwater_changed()
	_on_surface_changed()

func _on_time_changed():
	var hours:int = floor(Globals.time)
	var minutes:int = fmod(Globals.time, 1.0) * 60
	lbl_time_value.text = "%02d:%02d" % [hours, minutes]

func _on_zone_changed():
	lbl_zone_value.text = str(Globals.zone)
	
func _on_subzone_changed():
	lbl_subzone_value.text = str(Globals.subzone)

func _on_tension_changed():
	lbl_tension_value.text = "%.2f" % [Globals.tension]

func _on_surface_changed():
	lbl_surface_value.text = Globals.surface
	
func _on_underwater_changed():
	lbl_underwater_value.text = "True" if Globals.underwater else "False"
