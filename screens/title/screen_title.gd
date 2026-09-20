extends Control


func _on_btn_new_game_pressed():
	#ScreenFader.fade_to_scene("res://screens/play/screen_play.tscn")
	get_tree().change_scene_to_file("res://screens/play/screen_play.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()
