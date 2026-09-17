extends Area3D

@export var text:String

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node3D):
	if not body.is_in_group("player"): return
	#print("entered %s" % [body])
	Globals.subzone = text
	
func _on_body_exited(body: Node3D):
	if not body.is_in_group("player"): return
	#print("exited %s" % [body])
	Globals.subzone = ""
	
