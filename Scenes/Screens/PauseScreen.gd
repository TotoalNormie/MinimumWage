extends Control

func _on_resume_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
