extends TileMap


var elevatorDoors = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(tile_set.get_pattern(7))
	#set_pattern(0, Vector2i(0, 0), tile_set.get_pattern(0))
	generateLevel()


func generateLevel():
	var elevatorWalls = tile_set.get_pattern(6)
	var elevatorFloor = tile_set.get_pattern(7)
	var floor = tile_set.get_pattern(8)
	var middle = tile_set.get_pattern(3)
	var elevatorOffset = 5
	var roomLength = 16
	var middlePoint = roomLength / 2
	
	for row in 3:
		for col in 3:
			var roomId
			if row == 1 and col == 1:
				roomId = 3
			else:
				var rng = RandomNumberGenerator.new()
				roomId = rng.randi_range(0, 4)
				if roomId == 3: 
					roomId += 1
			
			#print(row, col, Vector2i(roomLength * col, roomLength * row + elevatorOffset))\
			var RoomCords = Vector2i(roomLength * col, roomLength * row + elevatorOffset)
			set_pattern(0, RoomCords, tile_set.get_pattern(roomId))
			set_pattern(1, RoomCords, floor)
			if row == 0 and col != 0:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y), 1, Vector2i(1, 0))
			elif row == 2:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y + roomLength), 1, Vector2i(1, 0))
		
		set_cell(0, Vector2i(0, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))
		set_cell(0, Vector2i(roomLength * 3, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))

	#set_pattern(1, Vector2i(6, 0), elevatorFloor)
	#set_pattern(0, Vector2i(6, 0), elevatorWalls)
	#
