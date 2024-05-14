extends Control

func start():
	get_tree().paused = false
	$AnimationPlayer.play("start")

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_pause_hidden():
	pass
