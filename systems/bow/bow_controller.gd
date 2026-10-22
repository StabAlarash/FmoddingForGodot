class_name BowController
extends Node
## Bow handling for the FPS character. Hold weapon_main (LMB) to draw, release to shoot.
## Hold weapon_second (RMB) to center the bow and focus the shot (no spread).
## Lives in the WeaponContainer under the character's camera; the bow model is a sibling of this node.

const ArrowScene := preload("res://systems/bow/arrow.tscn")

enum BowState { IDLE, DRAWING, RELOADING }

@export var bow: Bow
@export var camera: Camera3D
@export_group("Bow pose")
@export var hip_pose: Node3D ## bow placement when not focusing, a child of the weapon container
@export var aim_pose: Node3D ## bow placement while focusing, a child of the weapon container
@export var aim_fov := 55.0 ## narrower than the character's 75 default while focusing
@export_group("Shooting")
@export var draw_time := 1.2 ## seconds to reach full draw
@export var min_charge := 0.15 ## releasing below this cancels the shot
@export var min_arrow_speed := 10.0 ## m/s at minimum charge
@export var max_arrow_speed := 60.0 ## m/s at full draw
@export var reload_time := 0.4
@export var hip_spread_deg := 2.0 ## random inaccuracy when not aiming

var state := BowState.IDLE
var charge := 0.0
var aim_t := 0.0 # 0 = hip, 1 = fully centered
var aiming := false
var reload_left := 0.0
var kick := 0.0

@onready var character: CharacterBody3D = owner as CharacterBody3D

@export_group("Audio")
@export var audio_draw:FmodEventEmitter3D
@export var audio_shoot:FmodEventEmitter3D


func _unhandled_input(event: InputEvent) -> void:
	# Swallow the click that recaptures the mouse so it doesn't start drawing the bow.
	if event is InputEventMouseButton and event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		state = BowState.RELOADING
		reload_left = 0.2


func _process(delta: float) -> void:
	var captured := Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if not captured:
		return
	aiming = Input.is_action_pressed("weapon_second")
	character.focus_fov = aim_fov if aiming else 0.0
	_update_bow_state(delta)
	_update_bow_visuals(delta)


func _update_bow_state(delta: float) -> void:
	match state:
		BowState.IDLE:
			if Input.is_action_just_pressed("weapon_main"):
				state = BowState.DRAWING
				charge = 0.0
				audio_draw.play()
		BowState.DRAWING:
			charge = minf(charge + delta / draw_time, 1.0)
			if not Input.is_action_pressed("weapon_main"):
				audio_draw.stop()
				if charge >= min_charge:
					_fire()
				else:
					state = BowState.IDLE
					charge = 0.0
		BowState.RELOADING:
			reload_left -= delta
			if reload_left <= 0.0:
				state = BowState.IDLE


func _fire() -> void:
	audio_shoot.play()
	var cam_xf := camera.global_transform
	var forward := -cam_xf.basis.z

	# Aim at whatever is under the crosshair, even though the bow is held off-center.
	var far_point := cam_xf.origin + forward * 200.0
	var query := PhysicsRayQueryParameters3D.create(cam_xf.origin, far_point)
	query.exclude = [character.get_rid()]
	var hit := camera.get_world_3d().direct_space_state.intersect_ray(query)
	var target: Vector3 = hit.position if hit else far_point

	var tip := bow.get_arrow_tip()
	var dir := (target - tip).normalized()

	if not aiming and hip_spread_deg > 0.0:
		var spread := tan(deg_to_rad(hip_spread_deg))
		var right := dir.cross(Vector3.UP).normalized()
		var up := right.cross(dir)
		dir = (dir + right * randf_range(-spread, spread) + up * randf_range(-spread, spread)).normalized()

	var arrow := ArrowScene.instantiate() as Arrow
	get_tree().current_scene.add_child(arrow)
	arrow.launch(tip, cam_xf.origin, dir * lerpf(min_arrow_speed, max_arrow_speed, charge), character)

	state = BowState.RELOADING
	reload_left = reload_time
	charge = 0.0
	kick = 1.0


func _update_bow_visuals(delta: float) -> void:
	aim_t = lerpf(aim_t, 1.0 if aiming else 0.0, 1.0 - exp(-14.0 * delta))
	kick = move_toward(kick, 0.0, delta * 6.0)

	# Arms shake slightly at full draw unless the shot is focused.
	var tremble := (1.0 - aim_t) * 0.0015 * smoothstep(0.8, 1.0, charge)
	var pos := hip_pose.position.lerp(aim_pose.position, aim_t)
	pos += Vector3(randf_range(-1, 1), randf_range(-1, 1), 0.0) * tremble
	pos.z += kick * 0.04
	bow.position = pos
	bow.rotation_degrees = hip_pose.rotation_degrees.lerp(aim_pose.rotation_degrees, aim_t)

	bow.set_draw(charge)
	bow.set_arrow_visible(state != BowState.RELOADING)
