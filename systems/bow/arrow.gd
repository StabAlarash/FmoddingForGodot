class_name Arrow
extends Node3D
## A ballistic arrow. The node origin is the arrow *tip*, flying toward -Z.
## Movement is swept with a raycast every physics frame so fast arrows never tunnel.
## The same scene (arrow.tscn) is also used as the inert nocked arrow on the bow.

const LENGTH := 0.8 ## matches the mesh in assets/arrow.blend

@export var gravity := 9.8
@export var lifetime := 12.0
@export var stuck_lifetime := 20.0

var velocity := Vector3.ZERO
var _ray_from := Vector3.ZERO
var _flying := false
var _age := 0.0
var _exclude: Array[RID] = []


## Fires the arrow. `tip` is where it appears, `ray_origin` is where the first
## collision sweep starts (the camera), so it can't skip a wall the player stands against.
func launch(tip: Vector3, ray_origin: Vector3, initial_velocity: Vector3, shooter: CollisionObject3D = null) -> void:
	global_position = tip
	velocity = initial_velocity
	_ray_from = ray_origin
	if shooter:
		_exclude = [shooter.get_rid()]
	_orient()
	_flying = true


func _physics_process(delta: float) -> void:
	if not _flying:
		return

	_age += delta
	if _age > lifetime or global_position.y < -100.0:
		queue_free()
		return

	velocity.y -= gravity * delta
	var next := global_position + velocity * delta

	var query := PhysicsRayQueryParameters3D.create(_ray_from, next)
	query.exclude = _exclude
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit:
		_stick_into(hit)
		return

	global_position = next
	_ray_from = next
	_orient()


func _orient() -> void:
	if velocity.length_squared() < 0.01:
		return
	var dir := velocity.normalized()
	var up := Vector3.UP if absf(dir.y) < 0.99 else Vector3.RIGHT
	global_transform.basis = Basis.looking_at(dir, up)


func _stick_into(hit: Dictionary) -> void:
	_flying = false
	var dir := velocity.normalized()
	global_position = hit.position + dir * 0.08 # sink the tip slightly
	var collider: Object = hit.collider

	if collider is RigidBody3D:
		var body := collider as RigidBody3D
		body.apply_impulse(velocity * 0.1, hit.position - body.global_position)
		reparent.call_deferred(body, true) # ride along with the object we hit
	if collider.has_method("on_arrow_hit"):
		collider.on_arrow_hit(hit.position, velocity)

	velocity = Vector3.ZERO
	get_tree().create_timer(stuck_lifetime).timeout.connect(queue_free)
