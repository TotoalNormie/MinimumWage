extends RigidBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Define movement speed
@export var speed: float = 600
@export var hp: int = 2
var direction : int = 1
@export var inventory: Dictionary = {}
var rigidbody: RigidBody2D

func  _ready():
	if not has_node("RigidBody2D"):
		print("Warning: This script requires a RigidBody2D node as a child.")
		return
		rigidbody = get_node(".")
	
	

#func _process(delta):
	## Get user input
	#var input_vector = Vector2.ZERO
	#if Input.is_action_pressed("move_right"):
		#input_vector.x += 1
		#direction = 1
	#if Input.is_action_pressed("move_left"):
		#input_vector.x -= 1
		#direction = -1
		#
	#if Input.is_action_pressed("move_down"):
		#input_vector.y += 1
	#if Input.is_action_pressed("move_up"):
		#input_vector.y -= 1
		#
	#$Image.scale.x = direction * abs($Image.scale.x)
#
	## Normalize input vector to prevent faster diagonal movement
	#input_vector = input_vector.normalized()
#
	## Move the player
	#var collision = move_and_collide(input_vector * speed)
	## Check for collision and stop movement if colliding
	#if collision:
		#speed = 0
	#else:
		#speed = 3
		
#func _physics_process(delta):
	## Get user input
	#var input_vector = Vector2.ZERO
	#if Input.is_action_pressed("move_right"):
		#input_vector.x = 1
	#elif Input.is_action_pressed("move_left"):
		#input_vector.x = -1
#
	#if Input.is_action_pressed("move_down"):
		#input_vector.y = 1
	#elif Input.is_action_pressed("move_up"):
		#input_vector.y = -1
#
	## Normalize input vector for smooth diagonal movement
	#input_vector = input_vector.normalized()
#
	## Apply force based on input and direction
	#self.apply_central_impulse(input_vector * speed)
#
	## Update direction based on input (optional for animation)
	#if input_vector.x != 0:
		#direction = input_vector.x
		
func _physics_process(delta):
	# Get user input
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_vector.x = 1
		direction = 1
	elif Input.is_action_pressed("move_left"):
		input_vector.x = -1
		direction = -1

	if Input.is_action_pressed("move_down"):
		input_vector.y = 1
	elif Input.is_action_pressed("move_up"):
		input_vector.y = -1

	# Normalize input vector for smooth diagonal movement
	input_vector = input_vector.normalized()

	# Apply force based on input and direction
	if input_vector != Vector2.ZERO:
		self.linear_velocity = input_vector * speed
		$PlayerAnimation.play()
		#self.apply_central_impulse(input_vector * speed)
	else:
		self.linear_velocity = Vector2.ZERO
		$PlayerAnimation.stop()	

	# Update direction based on input (optional for animation)
	#if input_vector.x != 0:
		#direction = input_vector.x
	$PlayerAnimation.scale.x = direction * abs($PlayerAnimation.scale.x)


func addToInventory(itemId, itemData):
	inventory[itemId] = itemData
	
func removeFromInventory(itemId):
	inventory.erase(itemId)

#func _on_area_2d_body_entered(body):
	#print("Area entered")
	##$AudioStreamPlayer2D.play(sound)
	#pass # Replace with function body.
