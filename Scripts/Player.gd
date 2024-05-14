extends RigidBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var joystick = %joystick
signal on_player_death
# Define movement speed
@export var speed: float = 400
@export var health: int = 2
@export var maxHealth: int = 2
@export var itemSlots: int = 6
var direction : int = 1
#@export var inventory: Array = []
@export var inventory: Dictionary = {}
var activeSlot: int = 0
var money: int = 0

func  _ready():
	health = maxHealth
	%HpBar.max_value = maxHealth
	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	#print(OS.has_feature('touchscreen'))
	if OS.has_feature("mobile"):
	#if true:
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
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	%HpBar.value = health
	#print('attacked')
	if(health <= 0):
		#self.queue_free()
		#print('dead')
		emit_signal("on_player_death")
	%UI.hit(health, maxHealth)


func _physics_process(_delta):
	#print($UI/mobile)
	# uses the item in the current inventory slot

	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	if Input.is_action_just_pressed("shoot"):
		#removeFromInventory(inventory.keys()[activeSlot])
		#if len(inventory) > 0 && len(inventory) > activeSlot:
			#indventory[inventory.keys()[activeSlot]]["data"].use()
			#hit(1)
		pass

	# Get user input
	var prevSlot: int
	if Input.is_action_just_released("slot1"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 0
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("slot2"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 1
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("slot3"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 2
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("slot4"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 3
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("slot5"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 4
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("slot6"):
		if activeSlot < itemSlots - 1:
			prevSlot = activeSlot
			activeSlot = 5
			setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot)
			
	if Input.is_action_just_released("inv_down"):
		if activeSlot < itemSlots-2:
			activeSlot += 1
			changeActiveSlot(activeSlot)
	if Input.is_action_just_released("inv_up"):
		if activeSlot > 0:
			changeActiveSlot(activeSlot)
			activeSlot -= 1
			setInactiveSlot(activeSlot)
			
	var input_vector = Vector2.ZERO
	# Get user input
	
	if(!%UI/mobile.visible):
		if Input.is_action_pressed("move_right"):
			input_vector.x = 1
			direction = 1
		if Input.is_action_pressed("move_left"):
			input_vector.x = -1
			direction = -1

		if Input.is_action_pressed("move_down"):
			input_vector.y = 1
		if Input.is_action_pressed("move_up"):
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
	if(!%UI/mobile.visible):	
		$PlayerAnimation.scale.x = direction * abs($PlayerAnimation.scale.x)
	else:
		var deg = fmod(rad_to_deg(position.angle_to(input_vector)), 360)
		var playerDirection
		if abs(deg) > 90 and abs(deg) < 270:
			playerDirection = -1
		else:
			playerDirection = 1
		print(deg)
		$PlayerAnimation.scale.x = playerDirection * abs($PlayerAnimation.scale.x)
		


func addToInventory(itemId, itemData):
	inventory[itemId] = itemData
	#inventory.append(itemData)
	#for items in inventory:
		#print(items.use())
	#print(inventory)
	for item in %InvDisplay.get_children():
		var image = item.get_child(0)
		var amount = item.get_child(1)
		if image.texture == null:
			image.texture = inventory[itemId]["icon"]
			amount.text = str(inventory[itemId]["amount"])
			break
	print(inventory)
	
func getSlots():
	return len(inventory)
	
	
func removeFromInventory(itemId):
	#print(inventory[itemId])
	# check if slot has an item
	var item = %InvDisplay.get_child(activeSlot)
	var image = item.get_child(0)
	var amount = item.get_child(1)
	image.texture = null
	amount.text = "0"
	
	#var player = get_node(".")
	#var weapon = player.get_child(get_child_count()-1)
	#player.get_parent().get_node(".").add_child(weapon)
	#player.remove_child(weapon)
	# fix this
	# gets the name of weapon / maybe get weapon node and straigh up reparent
	#print(player.get_child(get_child_count()-1))
	# reparent from player to world
	#print(player.get_children())
	#var playerItem = get_node()
	#print(playerItem)
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

		
func setItemAmount(itemId, amount, object):
	if itemId in inventory:
		if "amount" in inventory[itemId]:
			inventory[itemId]["amount"] = amount
			inventory[itemId]["data"] = object
			#print(inventory)
			#for item in %InvDisplay.get_children():
				#print(item.get_child(0).texture)
				#if inventory[itemId]["icon"] = item.get_child(0)
				#var image = item.get_child(0)
				#var amount = item.get_child(1)
			#print(inventory)
		else:
			return 0
	else:
		return 0
		
		
func changeActiveSlot(slotId):
	#print(activeSlot)
	var current = %InvDisplay.get_child(slotId)
	if current:
		if current.size.y < current.size.x + 10:
			current.set_size(current.size + Vector2(0, 10))
		%UI.changeActiveSlot(slotId)
		
	
func setInactiveSlot(slotId):
	#print(activeSlot)
	%UI.setInactiveSlot(slotId)


func _on_button_button_down():
	Input.action_press('interact')



func _on_button_button_up():
	Input.action_release('interact')
	
