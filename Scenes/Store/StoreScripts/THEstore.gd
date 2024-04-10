extends Control


func _on_skin_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Store/THEstoreSkins.tscn")


func _on_upgrades_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Store/THEstoreUpgrades.tscn")


func _on_close_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/test.tscn")
