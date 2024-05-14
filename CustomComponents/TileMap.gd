extends TileMap


var elevatorDoors = Vector2.ZERO
signal level_generated(roomEmptyCells: Array, levelPosition: Array)

func generateLevel(level = 1, levelOffset = 2, levelRepeatAfter = 3):
	var elevatorWalls = tile_set.get_pattern(6)
	var elevatorFloor = tile_set.get_pattern(7)
	var floor = tile_set.get_pattern(8)
	var middle = tile_set.get_pattern(3)
	var elevatorOffset = 5
	var roomLength = 16
	var middlePoint = roomLength / 2
	var roomEmptyCells: Array
	var levelPosition: Dictionary
	var levelCalc = 1 if level <= levelOffset else int(ceil((level - levelOffset) / float(levelRepeatAfter)))
	var roomBlockWith = ceil(levelCalc / 3.0)
	var levelLength #in rooms
	var levelHeight #in rooms
	print(levelCalc, " ", type_string(typeof(levelCalc)))
	var levelState = levelCalc % 3
	
	if level <= levelOffset:
		levelLength = 1
		levelHeight = 1
	elif levelState == 1:
		levelLength = roomBlockWith * 2
		levelHeight = roomBlockWith
	elif levelState == 2:
		levelLength = roomBlockWith
		levelHeight = roomBlockWith * 2
	else:
		levelLength = roomBlockWith * 2
		levelHeight = roomBlockWith * 2
	
	#print(levelLength, " ", levelHeight, " idth: ", roomBlockWith)
	
	clear()

	
	for row in levelHeight:
		for col in levelLength:
			var rng = RandomNumberGenerator.new()
			var roomId = rng.randi_range(0, 5)
			
			var RoomCords = Vector2i(roomLength * col, roomLength * row + elevatorOffset)
			var RoomCordsLast = Vector2i(RoomCords.x + roomLength, RoomCords.y + roomLength)
			
			set_pattern(0, RoomCords, tile_set.get_pattern(roomId))
			set_pattern(1, RoomCords, floor)
			if row == 0 and col != 0:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y), 1, Vector2i(1, 0))
			if row == levelHeight - 1:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y + roomLength), 1, Vector2i(1, 0))
			
			var emptyCells = getEmptyCells(RoomCords, RoomCordsLast)
			roomEmptyCells.append(emptyCells)
			#print("col: ", col, " row: ", row)
			if row == 0 and col == 0:
				levelPosition["topLeft"] = getGlobalPosition(RoomCords)
			if row == 0 and col == levelLength - 1:
				levelPosition["topRight"] = getGlobalPosition(Vector2i(RoomCordsLast.x, RoomCords.y))
			if row == levelHeight - 1 and col == 0:
				levelPosition["bottomLeft"] = getGlobalPosition(Vector2i(RoomCords.x, RoomCordsLast.y))
			if row == levelHeight - 1 and col == levelLength - 1:
				levelPosition["bottomRight"] = getGlobalPosition(RoomCordsLast)
		#print("------------------------------------")
		set_cell(0, Vector2i(0, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))
		set_cell(0, Vector2i(roomLength * levelLength, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))

	#set_pattern(1, Vector2i(6, 0), elevatorFloor)
	#set_pattern(0, Vector2i(6, 0), elevatorWalls)
	level_generated.emit(roomEmptyCells, levelPosition)

func getGlobalPosition(cords: Vector2i) -> Vector2:
	return to_global(map_to_local(cords))

func getEmptyCells(cordsTop: Vector2i, cordsBottom: Vector2i) -> PackedVector2Array:
	var emptyCells: PackedVector2Array
	var cordsTopOffset = Vector2i(cordsTop.x + 1, cordsTop.y + 1)
	var cordsBottomOffset = Vector2i(cordsBottom.x - 1, cordsBottom.y - 1)
	var third = floor((cordsBottomOffset.y - cordsTopOffset.y) / 3)

	for y in range(cordsTopOffset.y + third - 1, cordsBottomOffset.y, third):
		for x in range(cordsTopOffset.x + third -1, cordsBottomOffset.x, third):
			var point = Vector2i(x, y)
			var correctPoint: Vector2i
			if !get_cell_tile_data(0, point):
				correctPoint = point
				#set_cell(0, point, 7, Vector2i(1, 0))
			else:
				correctPoint = checkNeighbours(point)
				#set_cell(0, checkNeighbours(point), 7, Vector2i(0, 0))
			var globalPoint = to_global(map_to_local(correctPoint))
			#set_cell(0, point, 7, Vector2i(1, 0))
			emptyCells.append(globalPoint)
	return emptyCells
	

func checkNeighbours(cords: Vector2i):
	var neighbours = [
		Vector2i.RIGHT,
		Vector2i.RIGHT + Vector2i.DOWN,
		Vector2i.DOWN,
		Vector2i.DOWN + Vector2i.LEFT,
		Vector2i.LEFT,
		Vector2i.LEFT + Vector2i.UP,
		Vector2i.UP,
		Vector2i.UP + Vector2i.RIGHT,
	]
	var layer = 1
	while true:
		for neighbour in neighbours:
			var neighbourCords = cords + neighbour * layer
			if !get_cell_tile_data(0, neighbourCords):
				#set_cell(0, neighbourCords, 7, Vector2i(0, 0))
				return neighbourCords
		layer += 1
	return Vector2i.ZERO
