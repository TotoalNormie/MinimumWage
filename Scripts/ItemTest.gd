extends RigidBody2D

var sprite: Sprite2D
@export var icon: CompressedTexture2D = load("res://Sprites/icon1.png")
@export var itemSize: float = 1
@export var id: String = "EXAMPLE_ITEM"
@export var itemName: String = "Example Item"
@export var itemColor: Color = "2b2b2bfa"
@export var AreaCollider: CollisionShape2D
@export_multiline var description: String
@export_enum("ITEM", "POWERUP") var type: String = "ITEM"
var touching: bool = false
var player: Node
var data: Dictionary = {}
var currentItemScene: String
var loadedItem

# Called when the node enters the scene tree for the first time.
func _ready():
	currentItemScene = self.get_parent().scene_file_path
	loadedItem = load(currentItemScene)
	sprite = get_node("Sprite2D")
	$Tooltip.visible = false
	data["description"] = description
	data["amount"] = 1
	data["icon"] = icon
	data["type"] = type
	data["data"] = self.get_parent()
	itemName = "[[color="+ itemColor.to_html() + "]" + itemName + "[/color]]"
	
	itemSize *= 27
	sprite.texture = icon
 	# Adjust CollisionShape2D based on desired scaling behavior
	$CollisionShape2D.shape.extents = Vector2(itemSize, itemSize)
	AreaCollider.shape.extents = Vector2(itemSize, itemSize)
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
	
	$Tooltip.text = "[center]" + itemName + "\n" + description + "[/center]"
	

# this function picks up item
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$Tooltip.visible = true
		touching = true
		player = body


func _on_area_2d_mouse_entered():
	$Tooltip.visible = true


func _on_area_2d_mouse_exited():
	$Tooltip.visible = false


func _on_area_2d_body_exited(body):
	$Tooltip.visible = false
	touching = false
	player = null


func _input(event):
	if event.is_action_pressed("interact") and touching and type == "ITEM":
		if player.getItemAmount(id) == 0 && player.getSlots() < player.itemSlots && player.getItems() < 4:
			player.addToInventory(id, data)
			# debug
			print(currentItemScene)
			loadedItem = loadedItem.instantiate()
			loadedItem.name = self.get_parent().name
			#print("Added item name: " + self.get_parent().name)
			loadedItem.position = player.position + Vector2(5, 5)
			# should add the weapon as a child to player
			player.add_child(loadedItem)
			print(player.get_children())
			# removes item from the ground but still stays in memory to be able to call use() function
			print("Self: ", self)
			print("Parent: ", self.get_parent())
			get_parent().remove_child(self)
			# same but test
			#player.get_parent().remove_child(self)
			# when we want to remove item from inventory then use code below
			#self.queue_free()
		elif player.getItemAmount(id) != 0:
			player.setItemAmount(id, player.getItemAmount(id)+1, self.get_parent())
			#self.queue_free()
	#if event.is_action_pressed("shoot"):
		#print("Self: ", self)
		#print("Parent: ", self.get_parent())
		#loadedItem = loadedItem.instantiate()
		#loadedItem.name = self.get_parent().name
		#self.get_parent().add_child(loadedItem)
		#print(self.id)
		#player.removeFromInventory(id)
