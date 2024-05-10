extends Node2D

var startCords = Vector2i(8, 2)
var enemyScene = preload("res://CustomComponents/Characters/enemy.tscn")
@export var level = 1
var roomEmptyCells: Array

func _ready():
	var localStartyCords = %OfficeTileMap.map_to_local(startCords)
	var globalStartPos = %OfficeTileMap.to_global(localStartyCords)
	%Player.global_position = globalStartPos
	

		

func nextLevel():
	level += 1
	%OfficeTileMap.generateLevel(level)


func _on_elevator_tile_map_on_level_complete():
	nextLevel()


func _on_office_tile_map_level_generated(_roomEmptyCells, levelPosition):
	#print(roomEmptyCells)
	#pass
	
	#for child in %OfficeTileMap.get_children():
		#if child.name == "Enemy":
		#child.queue_free()
		
	var new_navigation_mesh = NavigationPolygon.new()
	var bounding_outline = PackedVector2Array([levelPosition[2], levelPosition[0], levelPosition[1], levelPosition[3]])
	new_navigation_mesh.add_outline(bounding_outline)
	new_navigation_mesh.agent_radius = 15.5
	#NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
	$NavigationRegion2D.navigation_polygon = new_navigation_mesh
	$NavigationRegion2D.bake_navigation_polygon()
	
	roomEmptyCells = _roomEmptyCells
	#
	#for emptyCellsIndex in roomEmptyCells:
		#var emptyCells = emptyCellsIndex.duplicate()
		#var rng = RandomNumberGenerator.new()
		#var enemyCount = rng.randi_range(1, 3)
		#for i in enemyCount:
			#var enemy = enemyScene.instantiate()
			#var enemyCordsIndex = rng.randi_range(0, emptyCells.size() - 1)
			##print("spawn point: ", emptyCells, emptyCells.size())
			#var enemyCords = emptyCells[enemyCordsIndex]
			#emptyCells.remove_at(enemyCordsIndex)
			#var enemyGoToIndex = rng.randi_range(0, emptyCells.size() - 1)
			##print("go to point: ", emptyCells, emptyCells.size())
			#var enemyGoTo = emptyCells[enemyGoToIndex]
			#
			#emptyCells.remove_at(enemyGoToIndex)
			#
			#%OfficeTileMap.add_child(enemy)
			#enemy.start(enemyCords, enemyGoTo)
			#print(emptyCells[0])



func _on_navigation_region_2d_bake_finished():
	for emptyCellsIndex in roomEmptyCells:
		var emptyCells = emptyCellsIndex.duplicate()
		var rng = RandomNumberGenerator.new()
		var enemyCount = rng.randi_range(1, 3)
		for i in enemyCount:
			var enemy = enemyScene.instantiate()
			var enemyCordsIndex = rng.randi_range(0, emptyCells.size() - 1)
			#print("spawn point: ", emptyCells, emptyCells.size())
			var enemyCords = emptyCells[enemyCordsIndex]
			emptyCells.remove_at(enemyCordsIndex)
			var enemyGoToIndex = rng.randi_range(0, emptyCells.size() - 1)
			#print("go to point: ", emptyCells, emptyCells.size())
			var enemyGoTo = emptyCells[enemyGoToIndex]
			
			emptyCells.remove_at(enemyGoToIndex)
			
			%OfficeTileMap.add_child(enemy)
			enemy.start(enemyCords, enemyGoTo)
			#print(emptyCells[0])


#func _on_navigation_region_2d_navigation_polygon_changed():
	#print("navigation changed")
