extends Node2D

var startCords = Vector2i(8, 2)
var enemyScene = preload("res://CustomComponents/Characters/enemy.tscn")
var cardScene = preload("res://CustomComponents/elevator_card.tscn")
var level = 0
var roomEmptyCells: Array

func _ready():
	var localStartyCords = %OfficeTileMap.map_to_local(startCords)
	var globalStartPos = %OfficeTileMap.to_global(localStartyCords)
	%Player.global_position = globalStartPos
	

func _process(delta):
	if $Player.inventory.has('ELEVATOR_CARD'):
		$ElevatorTileMap.canComplete = true
	else:
		$ElevatorTileMap.canComplete = false
	
	if $ElevatorTileMap.start:
		%Level.visible = false
	else:
		%Level.text = str("level ", level)
		%Level.visible = true

func nextLevel():
	level += 1
	%OfficeTileMap.generateLevel(level)


func _on_elevator_tile_map_on_level_complete():
	nextLevel()
	$Player.removeFromInventory('ELEVATOR_CARD')


func _on_office_tile_map_level_generated(_roomEmptyCells, levelPosition):
	
	for child in %OfficeTileMap.get_children():
		if child.type == "enemy":
			child.queue_free()
		
	var new_navigation_mesh = NavigationPolygon.new()
	var bounding_outline = PackedVector2Array([levelPosition["bottomLeft"], levelPosition["topLeft"], levelPosition["topRight"], levelPosition["bottomRight"]])
	new_navigation_mesh.add_outline(bounding_outline)
	new_navigation_mesh.agent_radius = 15.5
	$NavigationRegion2D.navigation_polygon = new_navigation_mesh
	$NavigationRegion2D.bake_navigation_polygon()
	
	
	var grassPadding = 400
	var grassWidth = float(levelPosition["topRight"].x - levelPosition["topLeft"].x + (grassPadding * 2)) / 2
	var grassHeight = float(levelPosition["bottomRight"].y- levelPosition["topRight"].y + (grassPadding * 2)) / 2
	
	
	$Grass.texture.width = grassWidth
	$Grass.texture.height = grassHeight
	
	$Grass.position = Vector2(grassWidth - grassPadding, grassHeight - grassPadding)
	print(grassWidth, " ", grassHeight, " ", Vector2(grassWidth - grassPadding, grassHeight - grassPadding))
	
	
	roomEmptyCells = _roomEmptyCells



func _on_navigation_region_2d_bake_finished():
	var cardRoomIndex
	if roomEmptyCells.size() == 1:
		cardRoomIndex = 0
	else:
		cardRoomIndex = range(1, roomEmptyCells.size()).pick_random()
	for i in roomEmptyCells.size():
		
		var emptyCells = roomEmptyCells[i].duplicate()
		var rng = RandomNumberGenerator.new()
		var enemyCount = rng.randi_range(1, 3)
		for _i in enemyCount:
			var enemy = enemyScene.instantiate()
			var enemyCordsIndex = rng.randi_range(0, emptyCells.size() - 1)
			var enemyCords = emptyCells[enemyCordsIndex]
			emptyCells.remove_at(enemyCordsIndex)
			var enemyGoToIndex = rng.randi_range(0, emptyCells.size() - 1)
			var enemyGoTo = emptyCells[enemyGoToIndex]
			
			emptyCells.remove_at(enemyGoToIndex)
			
			%OfficeTileMap.add_child(enemy)
			enemy.start(enemyCords, enemyGoTo)
		if i == cardRoomIndex:
			var card = cardScene.instantiate()
			var cardIndex = rng.randi_range(0, emptyCells.size() - 1)
			add_child(card)
			card.global_position = emptyCells[cardIndex]
			card.scale.x = 0.3
			card.scale.y = 0.3
			emptyCells.remove_at(cardIndex)
