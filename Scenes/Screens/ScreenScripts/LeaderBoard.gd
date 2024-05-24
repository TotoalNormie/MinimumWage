extends Control

const DB_PATH = "res://Database/wage.db"

# Initialize the SQLite object
var db = SQLite.new()
var a = set
var board: Array[Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready():
	db.path = DB_PATH
	if db.open_db() != true:
		print("Failed to open database")
		return
	db.open_db()
	#var query = "select username, score from users order by score desc limit 10"
	var result = db.select_rows("users", '', ["username", "score"])
	#var result.query(query)
	if !result:
		print("Failed to execute statement")
		return null
	for i in range(len(result), 0, -1):
		var label = Label.new()
		#print(result[i].username)
		board.append({result[i-1].username: result[i-1].score})
		label.text = str(result[i-1].username) + " : " + str(result[i-1].score)
		%Display.add_child(label)
		#continue
	#board.sort()
	print(board)
	db.close_db()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
