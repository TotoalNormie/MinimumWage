extends RigidBody2D

var sprite: Sprite2D
@export var icon: CompressedTexture2D = load("res://Sprites/icon1.png")
@export var size: float = 1
@export var id: String = "EXAMPLE_ITEM"
@export var itemName: String = "Example Item"
@export var bg: Color = "2b2b2bfa"
@export var AreaCollider: CollisionShape2D
#@export var descriptionSize: Vector2 = Vector2(180, 60)
@export_multiline var description: String
#@export var padding: Vector2
var data: Dictionary = {}
#var style = StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	$Tooltip.visible = false
	data["description"] = description
	data["amount"] = 1
	itemName = "[[color=#cf1137]" + itemName + "[/color]]"
	#$Panel.color = bg
	
	size *= 27
	sprite.texture = icon
 	# Adjust CollisionShape2D based on desired scaling behavior
	$CollisionShape2D.shape.extents = Vector2(size, size)
	AreaCollider.shape.extents = Vector2(size, size)
	var collider_size = $CollisionShape2D.shape.extents * 2  # Get current collision size
	
	# scale image to collider
	# Calculate scaling factors based on desired fit behavior
	var col_scale_x = collider_size.x / sprite.texture.get_size().x
	var col_scale_y = collider_size.y / sprite.texture.get_size().y

	# Choose the larger scale factor to ensure full coverage (fit)
	var col_scale = max(col_scale_x, col_scale_y)  # Use max() function
	# Create a Vector2 object with the chosen scale factor
	var col_final_scale = Vector2(col_scale, col_scale)  # Apply the same scale to both X and Y
	# Set scale using a Vector2 object
	sprite.scale = col_final_scale
	
	$Tooltip.text = itemName + "\n" + description
	$Tooltip.text = "[center]%s[/center]" % $Tooltip.text
	#$Panel.size = $Panel/Margin/Tooltip.size

	# scale tooltip bg
	# Calculate scaling factors based on desired fit behavior
	#var scale_x = $Panel/Margin/Tooltip.get_size().x / $Panel.get_size().x
	#var scale_y = $Panel/Margin/Tooltip.get_size().y / $Panel.get_size().y
	#var scale = max(scale_x, scale_y)  # Use max() function
	#$Panel.size = Vector2(scale, scale)

	# Set scale using a Vector2 object
	#sprite.scale = final_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	

# this function picks up item
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if body.getItemAmount(id) == 0:
			body.addToInventory(id, data)
			print("Player Picked Up: ", id)
			print(body.inventory)
			self.queue_free()
		elif body.getItemAmount(id) != 0:
			body.setItemAmount(id, body.getItemAmount(id)+1)
			print("Player Picked Up: ", id)
			print(body.inventory)
			self.queue_free()


func _on_area_2d_mouse_entered():
	$Tooltip.visible = true
	#$Tooltip/Margin/Panel.set_size($Tooltip.size + Vector2(10, 10))


func _on_area_2d_mouse_exited():
	$Tooltip.visible = false
