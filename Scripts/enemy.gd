extends CharacterBody2D

@export var health: float = 4
@export var speed = 100
@export var player: Node2D
@onready var navAgent := $NavigationAgent2D


const type = 'enemy'

func _ready():
	$Label.text = str(health)
	makePath()
	
func _physics_process(delta: float) -> void:
	var dir = navAgent.get_next_path_position().normalized()
	#var dir = Vector2(0, -4).normalized()
	velocity = dir * speed
	print(navAgent.get_next_path_position())
	move_and_slide()

func makePath() -> void:
	navAgent.target_position = player.global_position


func damage(amount):
	health -= amount
	$Label.text = str(health)
	
	if(health <= 0):
		self.queue_free()
		
	


func _on_timer_timeout():
	makePath()
