extends RigidBody2D

var speed: float = 0
var velocity = Vector2.ZERO
var damage: float = 0
var dustScene = preload('res://CustomComponents/dust.tscn')

func _ready():
	pass

func start(_position, _direction, _speed, _damage):
	print(_direction)
	rotation = _direction
	global_position = _position
	##print(position)
	speed = _speed
	damage = _damage
	##print("Start bullet.gd: ", damage)
	velocity = Vector2(speed, 0).rotated(_direction)

# Called every frame. 'delta' is the elapstime since the previous frame.
func _process(delta) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		#velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			#print("Process bullet.gd: ", damage)
			collision.get_collider().hit(damage)
		var dust = dustScene.instantiate()
		#get_tree().get_root().add_child(dust)
		#dust.global_position = $DustFrom.global_position
		#dust.rotation = rotation + PI
		#
		#dust.emitting = true
		#print(dust)
		queue_free()
