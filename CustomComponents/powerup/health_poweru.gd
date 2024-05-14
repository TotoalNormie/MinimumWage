extends Node2D

@export var healAmount: int = 1
var powerupId

# Called when the node enters the scene tree for the first time.
func _ready():
	powerupId = %RigidBody2D.id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func use():
	# gets player
	var player = self.get_parent().get_node("Player")
	# check if current hp + healed < maxhp
	if player.health + healAmount <= player.maxHealth:
		# heal
		player.health += healAmount
		# remove from inv
		player.removeFromInventory(powerupId)
		#print("Healed ", healAmount)
	
