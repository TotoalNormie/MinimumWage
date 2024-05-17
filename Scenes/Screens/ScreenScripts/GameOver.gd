extends Control

@onready var ui = get_tree().get_root().get_node('main/game/Player/CanvasLayer/UI')

func _on_game_on_player_death(level):
	get_tree().paused = true
	ui.visible = false
	$AnimationPlayer.play("gameover")

func _on_restart_button_pressed():
	get_tree().paused = false
	ui.visible = true
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().paused = false
	ui.visible = true
	get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
