extends Context

@onready var lbl_targets_found = %lbl_targets_found
@onready var lbl_targets_total = %lbl_targets_total
@onready var lbl_timer = %lbl_timer
@onready var lbl_result = %lbl_result
@onready var targets_container = %Targets

@onready var challenge_start = %ChallengeStart
@onready var challenge_win = %ChallengeWin
@onready var challenge_loose = %ChallengeLoose

@export var time: float
@export var targets: int = 3

var remaining_targets: int
var total_targets: int

var completed: bool = false

func on_enter() -> void:
	Globals.tension = 1.0
	challenge_start.play()

func on_exit() -> void:
	Globals.tension = 0.0
	queue_free()

func _ready():
	lbl_result.hide()
	setup_targets()
	total_targets = targets
	remaining_targets = total_targets
	for target in targets_container.get_children():
		target.killed.connect(_on_target_killed)
	update_target_count()

func _process(delta):
	if completed:
		return
	time -= delta
	lbl_timer.text = "%d" % ceil(time)
	if time <= 0:
		lose()
	
func setup_targets():
	var all_targets = targets_container.get_children()
	if targets > all_targets.size():
		printerr("not enough targets available")
		targets = all_targets.size()
		return
	while all_targets.size() > targets:
		var t = all_targets.pick_random()
		all_targets.erase(t)
		t.queue_free()

func update_target_count():
	lbl_targets_total.text = str(total_targets)
	lbl_targets_found.text = str(remaining_targets)

func _on_target_killed():
	remaining_targets -= 1
	update_target_count()
	
	if remaining_targets == 0:
		win()

func win():
	challenge_win.play()
	completed = true
	
	lbl_result.show()
	lbl_result.text = "YOU WIN !!!"
	await  get_tree().create_timer(5).timeout
	
	finish()
	
func lose():
	challenge_loose.play()
	completed = true
	targets_container.queue_free()
	
	lbl_result.show()
	lbl_result.text = "YOU LOSE !!!"
	await  get_tree().create_timer(5).timeout
	
	finish()
