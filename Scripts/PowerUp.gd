extends RigidBody2D

var sprite: Sprite2D
@export var id: String
@export_multiline var description: String
@export var icon: CompressedTexture2D = load("res://Sprites/icon1.png")
@export var size: float = 1
@export var powerUpId: String = "EXAMPLE_POWERUP"
@export var powerUpName: String = "Example Powerup"
@export_enum("ITEM", "POWERUP") var type: String = "POWERUP"
@export var AreaCollider: CollisionShape2D
var data: Dictionary = {}
var touching: bool = false
var player: Node



# Called when the node enters the scene tree for the first time.
func _ready():
	data["description"] = description
	data["amount"] = 1
	data["icon"] = icon
	data["type"] = type
	$Tooltip.visible = false
	size *= 27
	sprite = get_node("Sprite2D")
	sprite.texture = icon
 	# Adjust CollisionShape2D based on desired scaling behavior
	$CollisionShape2D.shape.extents = Vector2(size, size)
	var collider_size = $CollisionShape2D.shape.extents * 2  # Get current collision size
	AreaCollider.shape.extents = Vector2(size, size)

	# Calculate scaling factors based on desired fit behavior
	var scale_x = collider_size.x / sprite.texture.get_size().x
	var scale_y = collider_size.y / sprite.texture.get_size().y
	# Choose the larger scale factor to ensure full coverage (fit)
	var scale = max(scale_x, scale_y)  # Use max() function
	# Create a Vector2 object with the chosen scale factor
	var final_scale = Vector2(scale, scale)  # Apply the same scale to both X and Y
	# Set scale using a Vector2 object
	sprite.scale = final_scale
	$Tooltip.text = "[center]" + powerUpName + "\n" + description + "[/center]"


func _on_area_2d_mouse_entered():
	$Tooltip.visible = true


func _on_area_2d_mouse_exited():
	$Tooltip.visible = false
	

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		touching = true
		$Tooltip.visible = true


func _on_area_2d_body_exited(body):
	#player = null
	touching = false
	$Tooltip.visible = false
	
	
func _input(event):
	if event.is_action_pressed("interact") and touching and type == "POWERUP":
		#print(player.getPowerUp())
		#if player.getItemAmount(id) == 0 && player.getSlots() < player.itemSlots:
		if player.getItemAmount(id) == 0 && player.getPowerUp() < 2 && player.getSlots() < player.itemSlots:
			player.addToInventory(id, data)
			self.queue_free()
		elif player.getItemAmount(id) != 0:
			player.setItemAmount(id, player.getItemAmount(id)+1)
			self.queue_free()


