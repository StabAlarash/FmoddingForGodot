class_name StateMachine extends Node

signal state_changed

@export var root:Node
@export var state:State

func _ready():
	if state:
		state.state_machine = self
		state.on_enter()

func set_state(s) -> void:
	if s is String:
		var node = get_node(s)
		if node == null:
			printerr("State %s not found" % s)
			return
		s = node
	
	if state:
		state.on_exit()
	state = s
	if state:
		state.state_machine = self
		state.on_enter()
		
	state_changed.emit()

func _process(delta):
	if state:
		state.on_process(delta)

func _physics_process(delta):
	if state:
		state.on_physic_process(delta)
