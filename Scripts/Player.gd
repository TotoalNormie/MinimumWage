extends RigidBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var joystick = %UI/mobile/joystick
signal on_player_death
# Define movement speed
@export var speed: float = 400
@export var health: int = 2
@export var maxHp: int = 2
@export var itemSlots: int = 4
var direction : int = 1
@export var inventory: Dictionary = {}
var activeSlot: int = 0

func  _ready():
	#print(get_scene_file_path())
	#print(get_path())
	#print(OS.has_feature('mobile'))
	if OS.has_feature("mobile"):
		%UI/mobile.visible = true
	else:
		%UI/mobile.visible = false
	
	#var slot = preload("res://CustomComponents/InvSlot.tscn")
	
	%UI.itemSlots = itemSlots
	#for i in range(itemSlots):
		#var slotUi = slot.instantiate()
		#slotUi.name = "Slot {int}".format({"int": i})
		#slotUi.set_size(Vector2(50, 50))
		#%InvDisplay.add_child(slotUi)
	changeActiveSlot(0)

func hit(amount):
	health -= amount
	#print('attacked')
	if(health <= 0):
		#self.queue_free()
		#print('dead')
		emit_signal("on_player_death")
	%UI.hit(health, maxHp)

func _physics_process(_delta):
	#if Input.is_action_just_released("interact"):
		#damage(1)
	# Get user input
	
	if Input.is_action_just_released("inv_down"):
		if activeSlot < itemSlots-1:
			activeSlot += 1
			setInactiveSlot(activeSlot-1)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("inv_up"):
		if activeSlot > 0:
			activeSlot -= 1
			changeActiveSlot(activeSlot)
			setInactiveSlot(activeSlot+1)
			
	var input_vector = Vector2.ZERO
	# Get user input
	
	if(!%UI/mobile.visible):
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
	else:
		if(joystick.posVector):
			input_vector = joystick.posVector
		else: 
			input_vector = Vector2(0,0)
		
	input_vector = input_vector.normalized()

	# Normalize input vector for smooth diagonal movement

	# Apply force based on input and direction

	if input_vector != Vector2.ZERO:
		
		linear_velocity = input_vector * speed
		$PlayerAnimation.play()
		#self.apply_central_impulse(input_vector * speed)
	else:
		linear_velocity = Vector2.ZERO
		$PlayerAnimation.stop()

	# Update direction based on input (optional for animation)
	#if input_vector.x != 0:
		#direction = input_vector.x
	$PlayerAnimation.scale.x = direction * abs($PlayerAnimation.scale.x)


func addToInventory(itemId, itemData):
	inventory[itemId] = itemData
	for item in %InvDisplay.get_children():
		var image = item.get_child(0)
		var amount = item.get_child(1)
		if image.texture == null:
			image.texture = inventory[itemId]["icon"]
			amount.text = str(inventory[itemId]["amount"])
			break
		
	
func getSlots():
	return len(inventory)
	
	
func removeFromInventory(itemId):
	inventory.erase(itemId)
	
	
func getItemAmount(itemId):
	if itemId in inventory:
		if "amount" in inventory[itemId]:
			return inventory[itemId]["amount"]
		else:
			return 0
	else:
		return 0
		
		
func getPowerUp():
	var count: int = 0
	var exec = 0
	for item in inventory.keys():
		var info = inventory[item]
		if info.type == "POWERUP":
			count += 1
	return count
	
	
func getItems():
	var count: int = 0
	var exec = 0
	for item in inventory.keys():
		var info = inventory[item]
		if info.type == "ITEM":
			count += 1
	return count

		
func setItemAmount(itemId, amount):
	if itemId in inventory:
		if "amount" in inventory[itemId]:
			inventory[itemId]["amount"] = amount
		else:
			return 0
	else:
		return 0
		
		
func changeActiveSlot(slotId):
	#print(activeSlot)
	%UI.changeActiveSlot(slotId)
	
	
func setInactiveSlot(slotId):
	#print(activeSlot)
	%UI.setInactiveSlot(slotId)
