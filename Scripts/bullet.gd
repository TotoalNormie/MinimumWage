extends RigidBody2D
# Called when the node enters the scene tree for the first time.
var speed: float = 0
var velocity = Vector2.ZERO
var damage: float = 0

func _ready():
	pass # Replace with function body.

func start(_position, _direction, _speed, _damage):
	rotation = _direction
	global_position = _position
	#print(position)
	speed = _speed
	damage = _damage
	velocity = Vector2(speed, 0).rotated(_direction)

# Called every frame. 'delta' is the elapstime since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		#velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit(damage)
			$Dust.emmiting = true
		queue_free()
	

