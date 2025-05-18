extends Control


func _on_btn_new_game_pressed():
	ScreenFader.fade_to_scene("res://screen_play/screen_play.tscn")
	#get_tree().change_scene_to_file("res://screen_play/screen_play.tscn")
