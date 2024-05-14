extends Control

@onready var ui = get_tree().get_root().get_node('main/game/Player/CanvasLayer/UI')
#func _ready():
	#$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	ui.visible = true
	$AnimationPlayer.play_backwards("pause")

func pause():
	get_tree().paused = true
	ui.visible = false
	
	$AnimationPlayer.play("pause")

func testEsc():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()

func _on_resume_button_pressed():
	resume()

func _on_menu_button_pressed():
	get_tree().paused = true
	$AnimationPlayer.play("start")

func _process(_delta):
	testEsc()


func _on_start_layer_replacing_by(node):
	pass # Replace with function body.
