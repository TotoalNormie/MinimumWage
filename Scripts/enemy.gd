extends CharacterBody2D

@export var health: float = 4
@export var speed = 100
@export var damage = 1
@export var range = 100
@onready var player = %Player
@onready var navAgent := $NavigationAgent2D

var canAttack = true


const type = 'enemy'

func _ready():
	$Label.text = str(health)
	makePath()
	
func _physics_process(delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	#var dir = Vector2(0, -4).normalized()
	#print(rad_to_deg(dir.angle()))aas
	velocity = speed * dir
	if global_position.distance_to(%Player.global_position) <= range:
		if canAttack: 
			$Weapon.attack(damage)
			canAttack = false
		$AttackTime.start()
	else:
		$AttackTime.stop()
	
	if $Weapon.isAttacking:
		velocity = Vector2.ZERO

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
	if rad_to_deg(dir.angle()) > 90 and rad_to_deg(dir.angle()) < 270:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * 1
	else:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * -1
	#print(navAgent.get_next_path_position(), " ", navAgent.get_next_path_position() )
	print(velocity)
	move_and_slide()

	
func makePath() -> void:
	navAgent.target_position = player.global_position


func hit(amount):
	health -= amount
	$Label.text = str(health)
	
	if(health <= 0):
		self.queue_free()

func _on_timer_timeout():
	makePath()


func _on_attack_time_timeout():
	canAttack = true
