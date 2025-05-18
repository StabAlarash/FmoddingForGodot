extends CharacterBody3D
class_name FPSController

@export var enabled: bool = true:
	set(value):
		enabled = value
		Input.set_mouse_mode(
			Input.MOUSE_MODE_CAPTURED if enabled else Input.MOUSE_MODE_VISIBLE
		)
		hud.visible = enabled

@export_subgroup("Movement")
@export var walk_speed = 5.0
@export var accel = 16.0
@export var jump_velocity = 6.0

@export_subgroup("Run")
@export var run_speed = 8.0

@export_subgroup("Crouching")
@export var crouch_speed = 4.0
@export var crouch_height = 1.0
@export var crouch_transition = 8.0

@export_subgroup("Camera")
@export var sensitivity = 0.5
@export var min_angle = -80.0
@export var max_angle = 90

@export_subgroup("Health")
@export var fall_damage_threshold = 15

var speed: float = 0.0

var stand_height: float
var old_vel := 0.0
var acceleration = Vector3()

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var collision = $Collision
@onready var top_cast = $TopCast
@onready var hud = $HUD

#@onready var sound_foot_step = $sound_foot_step
#@onready var sound_hurt = $sound_hurt
#@onready var sound_die = $sound_die

@onready var timer_coyote = $timer_coyote
var coyote_floor = false
@onready var timer_jump_buffer = $timer_jump_buffer
var jump_buffer = false

var move_phase := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot: Vector2

var push_list = []

func _ready():
	stand_height = collision.shape.height
	look_rot.y = rotation_degrees.y
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_basic_movement(delta)

func process_basic_movement(delta):
	speed = walk_speed
	#var phase_speed = 10.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_pressed("run"):
		speed = run_speed
		#phase_speed = 15.0

	# Handle jump.
	if is_on_floor():
		coyote_floor = true
	elif coyote_floor and timer_coyote.is_stopped():
		timer_coyote.start()
		
	if Input.is_action_just_pressed("jump"):
		jump_buffer = true
		timer_jump_buffer.stop()
		timer_jump_buffer.start()
		
	if jump_buffer and coyote_floor:
		velocity.y = jump_velocity
		coyote_floor = false
		timer_coyote.stop()
		
	elif Input.is_action_pressed("crouch") or top_cast.is_colliding():
		speed = crouch_speed
		#phase_speed = 6.0
		crouch(delta)
	else:
		crouch(delta, true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	else:
		speed = 0.0
		velocity.x = lerp(velocity.x, 0.0, accel * delta)
		velocity.z = lerp(velocity.z, 0.0, accel * delta)
		
	move_and_slide()
	process_fall(delta)

func process_fall(delta):
	# fall damage
	if old_vel < 0:
		var diff = velocity.y - old_vel
		if diff > fall_damage_threshold:
			#hurt(diff - fall_damage_threshold)
			crouch(delta)
	old_vel = velocity.y
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
		
		head.rotation_degrees.x = look_rot.x
		rotation_degrees.y = look_rot.y

func crouch(delta: float, reverse=false):
	var target_height: float = crouch_height if not reverse else stand_height
	
	collision.shape.height = lerp(collision.shape.height, target_height, crouch_transition * delta)
	collision.position.y = lerp(collision.position.y, target_height * 0.5, crouch_transition * delta)
	head.position.y = lerp(head.position.y, target_height - 0.5, crouch_transition * delta)

#func hurt(damage:float):
	#health_bar.value -= damage
	#hurt_overlay.modulate = Color.WHITE
	#if hurt_tween:
		#hurt_tween.kill()
	#hurt_tween = create_tween()
	#hurt_tween.tween_property(hurt_overlay, "modulate", Color.TRANSPARENT, 0.5)

#func _on_health_hurted(amount):
	#if amount >= health.value:
		#return
	#sound_hurt.pitch_scale = randf_range(0.9, 1.1)
	#sound_hurt.play()
	#
#func _on_health_zeroed():
	#sound_die.play()
	##get_tree().change_scene_to_file("res://scenes/screen_game_over.tscn")
	#Fader.fade_to_scene("res://scenes/screen_game_over.tscn")
#
#
#func _on_hit_box_damaged(amount):
	#health.hurt(amount)
	



func _on_timer_coyote_timeout():
	coyote_floor = false


func _on_timer_jump_buffer_timeout():
	jump_buffer = false
