extends Area2D

@onready var bigCircle = $BigCircle
var posVector: Vector2
#
#
#@onready var maxDistance = $CollisionShape2D.shape.radius
#
#var touched = false
#
#func _input(event) -> void:
	#if(event is InputEventScreenTouch):
		#var distance = event.position.distance_to()
		#if not touched:
			#print(event.position, "    ", distance, "   ", bigCircle.global_position)
			##print($CollisionShape2D.shape.radius)
			#if distance < $CollisionShape2D.shape.radius:
				#print('works')
				#touched = true
		#else:
			#smallCircle.position = Vector2(0, 0)
			#touched = false
#
#func _process(delta):
	#if touched:
		#smallCircle.global_position = get_global_mouse_position()
