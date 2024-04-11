extends CharacterBody2D

@export var health: float = 4
const type = 'enemy'

func _ready():
	$Label.text = str(health)

func damage(amount):
	health -= amount
	$Label.text = str(health)
	
	if(health <= 0):
		self.queue_free()
		
	
