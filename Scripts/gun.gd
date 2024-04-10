extends Area2D

var gun
var gunRotation = 0
# Called when the node enters the scene tree for the first time.
func _ready():

	gun = get_node(".")




func _process(delta):
	gun.look_at(get_global_mouse_position())
	gun.rotation += PI
	var deg = fmod(gun.rotation_degrees, 360)
	if(deg > 90 and deg < 270):
		$shape/Sprite2D.scale.y = abs($shape/Sprite2D.scale.y) * -1
	else:
		$shape/Sprite2D.scale.y = abs($shape/Sprite2D.scale.y)

func shoot():
	pass
