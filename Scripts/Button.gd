extends Button


func _ready():
	print("pressing")
	

func _on_button_down():
	Input.action_press("shoot_mobile")
	print("pressing")


func _on_button_up():
	Input.action_release("shoot_mobile")
	


func _on_mouse_entered():
	print("hovering")
