extends Control

func _ready():
	get_tree().paused = true

func start():
	get_tree().paused = false
	$AnimationPlayer.play("start")

func _on_start_button_pressed():
	start()


func _on_exit_button_pressed():
	get_tree().quit()

func _on_pause_hidden():
	
