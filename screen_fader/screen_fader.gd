extends CanvasLayer

@onready var color = $color
@onready var anim = $anim

var _callback#:Callable

func fade_to_scene(scene_path:String) -> void:
	_callback = get_tree().change_scene_to_file.bind(scene_path)
	anim.play("fade")

func fade_to_callback(callback:Callable) -> void:
	_callback = callback
	anim.play("fade")

func _anim_fade_callback() -> void:
	if _callback:
		_callback.call()
	_callback = null
