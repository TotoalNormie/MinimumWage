extends Control

func start():
	get_tree().paused = false
	$AnimationPlayer.play("start")
	
func _ready():
	print("Root child: ", get_tree().root.get_children())
	

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_pause_hidden():
	pass


func _on_leader_board_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/LeaderBoard.tscn")
