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
var money: int = 30
var score: int = 0
var username: String

# Path to your SQLite database
const DB_PATH = "res://Database/wage.db"
# Initialize the SQLite object
var db = SQLite.new()

func  _ready():
	health = maxHealth
	%HpBar.max_value = maxHealth
	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	if OS.has_feature("mobile"):
	#if true:
		%UI/mobile.visible = true
	else:
		%UI/mobile.visible = false
	%Score.text = "Score: {str}".format({"str": score})
	%ScoreCounter.start(0.1)
	username = get_tree().root.get_child(0).get_child(get_child_count()).name
	#print(get_tree().root.get_child(0).get_child(get_child_count()).name)
	
	#var slot = preload("res://CustomComponents/InvSlot.tscn")
	
	#%UI.itemSlots = itemSlots
	#for i in range(%UI.itemSlots):
		#$UI.get_child(i).size -= Vector2(0, 10) 
		#var slotUi = slot.instantiate()
		#slotUi.name = "Slot {int}".format({"int": i})
		#slotUi.set_size(Vector2(50, 50))
		#print(i)
		#var test = %InvDisplay.get_children()
		#print(test)
		#test.set_size(Vector2(80, 80))
		#%InvDisplay.get_child(i).size = Vector2(80, 80)
	#changeActiveSlot(itemSlots-1, itemSlots-2)

func hit(amount):
	health -= amount
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	%HpBar.value = health
	if(health <= 0):
		#self.queue_free()
		
		db.path = DB_PATH
		if db.open_db() != true:
			print("Failed to open database")
			return
		#var query = "INSERT INTO users (score) VALUES (?)"
		#var statement = db.query_with_bindings(query, [score])
		#if !statement:
				#print("Failed to insert")
				#return false
		else:
			var result = db.select_rows("users", 'username = "'+username+'"', ["score"])
			if !result:
				var query = "INSERT INTO users (score) VALUES (?)"
				var statement = db.query_with_bindings(query, [score])
				db.close_db()
				if !statement:
					print("Failed to insert")
					return false
			else:
				var query = "UPDATE users SET score = ? WHERE username = ?"
				var statement = db.query_with_bindings(query, [score, username])
				db.close_db()
				if !statement:
					print("Failed to insert")
					return false
		%ScoreCounter.stop()
		print("Final Score: ", score)
		emit_signal("on_player_death")
		return true
	%UI.hit(health, maxHealth)

func _process(delta):
	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHealth) * health)) + "%[/center]"
	%MoneyDisplay.text = str(money) + "G"
	%Score.text = "Score: {str}".format({"str": score})

	# Get user input
	var prevSlot: int
	if Input.is_action_just_released("slot1"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 0
			#setInactiveSlot()
			changeActiveSlot(activeSlot, prevSlot)
	if Input.is_action_just_released("slot2"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 1
			#setInactiveSlot()
			changeActiveSlot(activeSlot, prevSlot)
	if Input.is_action_just_released("slot3"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 2
			#setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot, prevSlot)
	if Input.is_action_just_released("slot4"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 3
			#setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot, prevSlot)
	if Input.is_action_just_released("slot5"):
		if activeSlot <= itemSlots-1:
			prevSlot = activeSlot
			activeSlot = 4
			#setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot, prevSlot)
	if Input.is_action_just_released("slot6"):
		if activeSlot < itemSlots - 1:
			prevSlot = activeSlot
			activeSlot = 5
			#setInactiveSlot(prevSlot)
			changeActiveSlot(activeSlot, prevSlot)
			
	#if Input.is_action_just_released("inv_up"):
		#if activeSlot < itemSlots-2:
			#activeSlot += 1
			#changeActiveSlot(activeSlot, activeSlot-2)
	#if Input.is_action_just_released("inv_down"):
		#if activeSlot > 0:
			#changeActiveSlot(activeSlot-1, activeSlot)


	
	if Input.is_action_just_pressed("interact") and !inventory.keys().is_empty():
		var invKeys = inventory.keys()
		#print(invKeys.size() - 1)
		#if activeSlot >= invKeys.size() - 1:
			#print("Fitogus fucked")
			#return
		# TODO siten ir bug line below
		var item = inventory[invKeys[activeSlot]].data
		#item.use()
		if item.has_method("use"):
			item.use()
		print(item)

func _physics_process(_delta):
	# uses the item in the current inventory slot

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
		$PlayerAnimation.scale.x = playerDirection * abs($PlayerAnimation.scale.x)
		


func addToInventory(itemId, itemData):
	inventory[itemId] = itemData
	#inventory.append(itemData)
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
	# check if slot has an item
	var inventoryIndex = inventory.keys().find(itemId)
	if(inventoryIndex > -1):
		var item = %InvDisplay.get_child(inventoryIndex)
		var image = item.get_child(0)
		var amount = item.get_child(1)
		image.texture = null
		amount.text = "0"
		inventory.erase(itemId)
	
	#var player = get_node(".")
	#var weapon = player.get_child(get_child_count()-1)
	#player.get_parent().get_node(".").add_child(weapon)
	#player.remove_child(weapon)
	# fix this
	# gets the name of weapon / maybe get weapon node and straigh up reparent
	
	
	
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

			#for item in %InvDisplay.get_children():

				#if inventory[itemId]["icon"] = item.get_child(0)
				#var image = item.get_child(0)
				#var amount = item.get_child(1)

		else:
			return 0
	else:
		return 0
		
		
func changeActiveSlot(slotId, prevSlot):
	#print(activeSlot)
	#slotId += 1
	var current = %InvDisplay.get_child(slotId)
	#%UI.changeActiveSlot(slotId, prevSlot)
	if current:
		#print("y: ", current.size.y, " x: ", current.size.x)
		if current.size.y < current.size.x + 11:
			#current.set_size(current.size + Vector2(0, 10))
			%UI.changeActiveSlot(slotId, prevSlot)
		else:
			print("wrong size", current.size)		
	
func setInactiveSlot(slotId):
	#print(activeSlot)
	#%UI.setInactiveSlot(slotId)
	var current = %InvDisplay.get_child(slotId)
	if current:
		if current.size.y > current.size.x:
			#current.set_size(current.size - Vector2(0, 10))
			%UI.setInactiveSlot(slotId)


func _on_score_counter_timeout():
	score += 1
