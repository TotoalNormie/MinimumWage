extends Node2D

var startCords = Vector2i(8, 2)
# Called when the node enters the scene tree for the first time.
func _ready():
	var localStartyCords = $TileMap.map_to_local(startCords)
	var globalStartPos = $TileMap.to_global(localStartyCords)
	$Player.global_position = globalStartPos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
