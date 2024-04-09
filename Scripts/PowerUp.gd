extends RigidBody2D

var sprite: Sprite2D
@export var icon: CompressedTexture2D = load("res://Sprites/icon1.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	sprite.texture = icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
