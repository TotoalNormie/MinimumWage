extends Node

# Import necessary libraries
#const Crypto = preload("res://addons/godot-sqlite/Crypto.gd")


# Path to your SQLite database
const DB_PATH = "res://Database/wage.db"

# Initialize the SQLite object
var db = SQLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(sha_256("aaaa"))
	#Open the database
	db.path = DB_PATH
	if db.open_db() != true:
		print("Failed to open database")
		return
		
	#var password = "testogus_password"
	#if login("testogus", password):
		#print("yay")
	#else:
		#print("sad")
	#if register("silvis", "silvis", "silvis"):
		#print("yay")
	#else:
		#print("sad")

	# Example usage
	#var username = "example_user"
	#var password = "example_password"
	#if insert_user(username, password):
		#print("User inserted successfully")
	#else:
		#print("Failed to insert user")
	
	# Close the database
	#db.close_db()
	
	
# Function to insert a user with a hashed password
func get_user(username: String):
	#var result = db.query_with_bindings(query, [username, password])
	db.open_db()
	var result = db.select_rows("users", 'username = "'+username+'"', ["password"])
	
	if !result:
		print("Failed to execute statement")
		return null
	
	print(result)
	return result

# Function to hash a password using SHA-256
#func hash_password(password: String) -> String:
	#var hash = Crypto.new()
	#return hash.sha256(password)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func login(username: String, password: String) -> bool:
	db.open_db()
	var usrPass = get_user(username)
	if !usrPass:
		print("User Not Found.")
		return false
	if sha_256(password) == sha_256(usrPass[0].password):
		print("User found logging in")
		return true
	else:
		return false
		
		
func register(username: String, password: String, repeat: String) -> bool:
	db.open_db()
	if repeat == password && !get_user(username):
		var query = "INSERT INTO users (username, password) VALUES (?, ?)"
		var statement = db.query_with_bindings(query, [username, password])
		db.close_db()
		
		if !statement:
			print("Failed to create statement")
			return false
		print("User: ", username, " succesfully registered!")
		return true
	elif password != repeat:
		print("passwords don't match")
		return false
	else:
		print("User already in DB.")
		return false
	
		

# login
	
	
func sha_256(str: String) -> String:
	return str.sha256_text()


func _on_button_pressed():
	var currentSceneName = get_tree().get_current_scene().get_name()
	var username = %Username.text
	var password = %Password.text
	if currentSceneName == "Login":
		if login(username, password):
			var temp = Node2D.new()
			temp.name = username
			get_tree().root.get_child(0).add_child(temp)
			get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
		else:
			pass
	elif currentSceneName == "Register":
		var repeat = %Repeat.text
		print("Register Scene")
		if register(username, password, repeat):
			var temp = Node2D.new()
			temp.name = username
			get_tree().root.get_child(0).add_child(temp)
			get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
		else:
			pass


func _on_change_login_pressed():
	var currentSceneName = get_tree().get_current_scene().get_name()
	if currentSceneName == "Login":
		get_tree().change_scene_to_file("res://Scenes/Screens/Register.tscn")


func _on_register_pressed():
	var currentSceneName = get_tree().get_current_scene().get_name()
	var username = %Username.text
	var password = %Password.text
	if currentSceneName == "Login":
		if login(username, password):
			var temp = Node2D.new()
			temp.name = username
			get_tree().root.get_child(0).add_child(temp)
			get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
		else:
			pass
	elif currentSceneName == "Register":
		var repeat = %Repeat.text
		print("Register Scene")
		if register(username, password, repeat):
			var temp = Node2D.new()
			temp.name = username
			get_tree().root.get_child(0).add_child(temp)
			get_tree().change_scene_to_file("res://Scenes/Screens/StartScreen.tscn")
		else:
			pass
