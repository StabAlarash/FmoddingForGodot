extends Control

@onready var lbl_zone_value = %lbl_zone_value
@onready var lbl_tension_value = %lbl_tension_value

func _ready():
	Globals.zone_changed.connect(_on_zone_changed)
	Globals.tension_changed.connect(_on_tension_changed)
	_on_zone_changed()
	_on_tension_changed()

func _on_zone_changed():
	lbl_zone_value.text = str(Globals.zone)

func _on_tension_changed():
	lbl_tension_value.text = "%.2f" % [Globals.tension]
