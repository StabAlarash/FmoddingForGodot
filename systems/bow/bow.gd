class_name Bow
extends Node3D
## Bow visuals: the model comes from assets/bow.blend, the string is redrawn every frame
## so it can bend back to the nocked arrow. Bow-local space: grip at the origin, limbs along Y,
## the archer toward +Z.

const LIMB_HALF := 0.3 ## matches the mesh in assets/bow.blend
const NOCK_REST := 0.1 ## string z when not drawn (limb tips)
const DRAW_LENGTH := 0.4 ## how far the string travels back at full draw

@onready var string_instance: MeshInstance3D = $String
@onready var nocked_arrow: Arrow = $NockedArrow

var _string_mesh: ImmediateMesh


func _ready() -> void:
	_string_mesh = string_instance.mesh as ImmediateMesh
	set_draw(0.0)


## `amount` is the draw strength from 0 (relaxed) to 1 (full draw).
func set_draw(amount: float) -> void:
	var nock := Vector3(0.0, 0.0, NOCK_REST + DRAW_LENGTH * amount)
	_string_mesh.clear_surfaces()
	_string_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	_string_mesh.surface_add_vertex(Vector3(0.0, LIMB_HALF, NOCK_REST))
	_string_mesh.surface_add_vertex(nock)
	_string_mesh.surface_add_vertex(Vector3(0.0, -LIMB_HALF, NOCK_REST))
	_string_mesh.surface_end()

	# The arrow's origin is its tip, so shift it forward by its length to put the tail on the string.
	nocked_arrow.position = nock - Vector3(0.0, 0.0, Arrow.LENGTH)


func set_arrow_visible(shown: bool) -> void:
	nocked_arrow.visible = shown


## World position where a fired arrow should appear.
func get_arrow_tip() -> Vector3:
	return nocked_arrow.global_position
