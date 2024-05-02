extends Node2D

var startCords = Vector2i(8, 2)

func _ready():
	var localStartyCords = $OfficeTileMap.map_to_local(startCords)
	var globalStartPos = $OfficeTileMap.to_global(localStartyCords)
	%Player.global_position = globalStartPos
