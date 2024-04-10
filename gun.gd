extends Area2D

var center: Vector2
var last_position = Vector2.ZERO
var gun
var gunRotation = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	gun = get_node(".")
	center = get_viewport_rect().size / 2
	print(center)
	pass

func _process(delta):
	var current_mouse_position = get_global_mouse_position()
	var diff = current_mouse_position - last_position
	if(diff != Vector2.ZERO):
		#print(rad_to_deg(last_position.angle_to_point(current_mouse_position)))
		gunRotation = current_mouse_position.angle_to_point(current_mouse_position)
	
	gun.rotation =  gunRotation
	
	last_position = current_mouse_position
