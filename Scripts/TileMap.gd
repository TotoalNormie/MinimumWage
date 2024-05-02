extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Assuming your tilemap is named "TileMap" in the scene

# Function to convert the tilemap into a room template array
func convertTilemapToRoomTemplate():
	var roomTemplate = []

	# Get the size of the tilemap
	var mapSize = get_used_rect()

	# Iterate over each cell in the tilemap
	for y in range(mapSize.size.y):
		var row = []
		for x in range(mapSize.size.x):
			# Get the tile ID at the current cell
			var tileID = get_cell(x, y)

			# Add the tile ID to the current row
			row.append(tileID)
		# Add the row to the room template
		roomTemplate.append(row)

	return roomTemplate
