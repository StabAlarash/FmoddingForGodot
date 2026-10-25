class_name WeaponSway
extends Node3D
## Sways the weapon container with movement (bob, strafe tilt) and camera turning (lag).
## Lives under the character's camera and moves everything inside it, so poses and the
## weapon stay relative to each other. Sway is damped while focusing.

@export var character: CharacterBody3D
@export var controller: BowController ## read for aim_t, to damp the sway while focusing
@export_group("Movement")
@export var bob_amount := 0.012 ## meters
@export var bob_speed := 2.2 ## bob cycles per meter walked, times 2*PI
@export var strafe_tilt := 0.02 ## radians of roll per m/s of sideways speed
@export var forward_push := 0.004 ## meters of z offset per m/s of forward speed
@export_group("Looking")
@export var look_lag := 0.02 ## radians of weapon lag per rad/s of camera turn rate
@export var max_look_lag := 0.12 ## radians
@export_group("Response")
@export var smoothing := 10.0 ## higher is snappier
@export_range(0.0, 1.0) var aim_damping := 0.15 ## fraction of the sway left while focusing

var _phase := 0.0
var _prev_basis := Basis.IDENTITY
var _target_pos := Vector3.ZERO
var _target_rot := Vector3.ZERO

@onready var camera: Camera3D = get_parent() as Camera3D


func _ready() -> void:
	_prev_basis = camera.global_basis


func _process(delta: float) -> void:
	if delta <= 0.0:
		return

	# Camera turn this frame, expressed in camera space.
	var turn := (_prev_basis.inverse() * camera.global_basis).get_euler()
	_prev_basis = camera.global_basis
	var yaw_rate := turn.y / delta
	var pitch_rate := turn.x / delta

	var local_vel := camera.global_basis.inverse() * character.velocity
	var planar := Vector2(local_vel.x, local_vel.z)
	var grounded := character.is_on_floor()
	if grounded:
		_phase += planar.length() * delta * bob_speed * TAU / 2.0
	var bob_strength := clampf(planar.length() / 3.0, 0.0, 1.5) if grounded else 0.0

	_target_pos = Vector3(
		sin(_phase) * bob_amount * bob_strength,
		-absf(cos(_phase)) * bob_amount * 0.7 * bob_strength,
		local_vel.z * forward_push,
	)
	_target_rot = Vector3(
		clampf(-pitch_rate * look_lag, -max_look_lag, max_look_lag),
		clampf(-yaw_rate * look_lag, -max_look_lag, max_look_lag),
		-local_vel.x * strafe_tilt,
	)

	var damp := lerpf(1.0, aim_damping, controller.aim_t if controller else 0.0)
	var weight := 1.0 - exp(-smoothing * delta)
	position = position.lerp(_target_pos * damp, weight)
	rotation = rotation.lerp(_target_rot * damp, weight)
