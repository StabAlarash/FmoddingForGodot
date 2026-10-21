extends Node3D

@export var character: FPSCharacter

@onready var jump = $Jump
@onready var landing = $Landing

func _ready():
	character.jumped.connect(jump.play)
	character.landed.connect(landing.play)
	
	Globals.surface_changed.connect(_on_surface_changed)
	
func _on_surface_changed():
	jump.set_parameter("Surface", Globals.surface)
	landing.set_parameter("Surface", Globals.surface)
