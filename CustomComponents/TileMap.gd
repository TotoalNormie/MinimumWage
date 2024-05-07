extends TileMap


var elevatorDoors = Vector2.ZERO
signal level_generated(roomEmptyCells: Array, levelPosition: Array)
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(tile_set.get_pattern(7))
	#set_pattern(0, Vector2i(0, 0), tile_set.get_pattern(0))
	#generateLevel()
	pass


func generateLevel(level = 1):
	var elevatorWalls = tile_set.get_pattern(6)
	var elevatorFloor = tile_set.get_pattern(7)
	var floor = tile_set.get_pattern(8)
	var middle = tile_set.get_pattern(3)
	var elevatorOffset = 5
	var roomLength = 16
	var middlePoint = roomLength / 2
	var roomEmptyCells: Array
	var levelPosition: PackedVector2Array
	var leveLength = 2 #in rooms
	var levelHeight= 2 #in rooms
	
	
	clear()
	#print(Vector2i(0, 2) % 2)
	
	for row in levelHeight:
		for col in leveLength:
			var roomId
			var rng = RandomNumberGenerator.new()
			if row == 1 and col == 1:
				roomId = 3
			else:
				roomId = rng.randi_range(0, 4)
				if roomId == 3: 
					roomId += 1
			
			var RoomCords = Vector2i(roomLength * col, roomLength * row + elevatorOffset)
			var RoomCordsLast = Vector2i(RoomCords.x + roomLength, RoomCords.y + roomLength)
				
				
				
			#print(row, col, Vector2i(roomLength * col, roomLength * row + elevatorOffset))\
			set_pattern(0, RoomCords, tile_set.get_pattern(roomId))
			set_pattern(1, RoomCords, floor)
			if row == 0 and col != 0:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y), 1, Vector2i(1, 0))
			elif row == levelHeight - 1:
				set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y + roomLength), 1, Vector2i(1, 0))
			
			var emptyCells = getEmptyCells(RoomCords, RoomCordsLast)
			roomEmptyCells.append(emptyCells)
			if row == 0 and col == 0:
				levelPosition.append(getGlobalPosition(RoomCords))
				set_cell(0, RoomCords, 7, Vector2i(0, 0))
				print(RoomCords)
			elif row == 0 and col == leveLength - 1:
				levelPosition.append(getGlobalPosition(Vector2i(RoomCordsLast.x, RoomCords.y)))
				set_cell(0, Vector2i(RoomCordsLast.x, RoomCords.y), 7, Vector2i(0, 0))
				print(Vector2i(RoomCordsLast.x, RoomCords.y))
				
			elif row == leveLength - 1 and col == 0:
				levelPosition.append(getGlobalPosition(Vector2i(RoomCords.x, RoomCordsLast.y)))
				set_cell(0, Vector2i(RoomCords.x, RoomCordsLast.y), 7, Vector2i(0, 0))
				print(Vector2i(RoomCords.x, RoomCordsLast.y))
				
			elif row == leveLength - 1 and col == leveLength - 1:
				levelPosition.append(getGlobalPosition(RoomCordsLast))
				set_cell(0, RoomCordsLast, 7, Vector2i(0, 0))
				print(RoomCordsLast)
		set_cell(0, Vector2i(0, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))
		set_cell(0, Vector2i(roomLength * leveLength, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))

	#set_pattern(1, Vector2i(6, 0), elevatorFloor)
	#set_pattern(0, Vector2i(6, 0), elevatorWalls)
	level_generated.emit(roomEmptyCells, levelPosition)

func getGlobalPosition(cords: Vector2i) -> Vector2:
	return to_global(map_to_local(cords))

func getEmptyCells(cordsTop: Vector2i, cordsBottom: Vector2i) -> PackedVector2Array:
	var emptyCells: PackedVector2Array
	#for y in range(cordsTop.y, cordsBottom.y):
		#for x in range(cordsTop.x, cordsBottom.x):
			#if !get_cell_tile_data(0, Vector2i(x, y)):
				#var globalCellPosition = map_to_local(Vector2(x, y))
				#var halfTile = tile_set.tile_size / 2
				#var center = Vector2(globalCellPosition.x + halfTile.x, globalCellPosition.y + halfTile.y)
				#print(center)
				#empatyCells.append(globalCellPosition)
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
