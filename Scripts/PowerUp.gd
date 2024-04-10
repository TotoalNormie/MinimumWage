extends RigidBody2D

var sprite: Sprite2D
@export var icon: CompressedTexture2D = load("res://Sprites/icon1.png")
@export var size: float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	size *= 27
	sprite = get_node("Sprite2D")
	sprite.texture = icon
 	# Adjust CollisionShape2D based on desired scaling behavior
	$CollisionShape2D.shape.extents = Vector2(size, size)
	var collider_size = $CollisionShape2D.shape.extents * 2  # Get current collision size

	# Calculate scaling factors based on desired fit behavior
	var scale_x = collider_size.x / sprite.texture.get_size().x
	var scale_y = collider_size.y / sprite.texture.get_size().y

	# Choose the larger scale factor to ensure full coverage (fit)
	var scale = max(scale_x, scale_y)  # Use max() function
	# Create a Vector2 object with the chosen scale factor
	var final_scale = Vector2(scale, scale)  # Apply the same scale to both X and Y

	# Set scale using a Vector2 object
	sprite.scale = final_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
