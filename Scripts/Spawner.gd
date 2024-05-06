extends Node2D

@export var SpawnableObj: Array = []
@export var amount: int = 1
@export var random: bool = false
#@onready var rootNode = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	#top_level=true
	var dir = DirAccess.open("res://CustomComponents/")
	for file in dir.get_files():
		var path = "res://CustomComponents/" + file
		SpawnableObj.append(load(path))
	if !random:
		var randomScene = SpawnableObj[0]
		var rootNode = self.get_parent()
		var sceneInstance = randomScene.instantiate()
		sceneInstance.name = "SpawnedObject"
		for i in range(amount):
			rootNode.add_child.call_deferred(sceneInstance)
	else:
		for i in range(amount):
			var randomScene = SpawnableObj.pick_random()
			var rootNode = self.get_parent()
			var sceneInstance = randomScene.instantiate()
			sceneInstance.name = "SpawnedObject"
			rootNode.add_child.call_deferred(sceneInstance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
