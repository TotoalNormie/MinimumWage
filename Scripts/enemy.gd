extends CharacterBody2D

@export var health: float = 4
@export var speed = 100
@export var damage = 1
@export var attackRange = 100
@onready var player = $"../%Player"
@onready var navAgent := $NavigationAgent2D


var canAttack = true
var spawnPoint: Vector2i
var goToPoint: Vector2i

const type = 'enemy'

func _ready():
	$Label.text = str(health)
	
func _physics_process(delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()

	#print(rad_to_deg(dir.angle()))
	velocity = speed * dir
	if global_position.distance_to(player.global_position) <= attackRange:
		velocity = Vector2.ZERO
		if canAttack: 
			$Weapon.attack(damage)
			canAttack = false
			$AttackTime.start()
			
	else:
		$AttackTime.stop()
	
	if $Weapon.isAttacking or $Weapon.isCharging:
		velocity = Vector2.ZERO
	#print(velocity)

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
	if abs(rad_to_deg(dir.angle())) > 90 and abs(rad_to_deg(dir.angle())) < 270:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * 1
	else:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * -1
	#print(navAgent.get_next_path_position(), " ", navAgent.get_next_path_position() )
	#print(canAttack)
	move_and_slide()

func start(_spawnPoint, _goToPoint):
	spawnPoint = _spawnPoint
	goToPoint = _goToPoint
	#print(goToPoint)
	global_position = spawnPoint
	makePath()


func makePath() -> void:
	#navAgent.target_position = player.global_position
	navAgent.target_position = goToPoint
	
	
	pass


func hit(amount):
	health -= amount
	$Label.text = str(health)
	
	if(health <= 0):
		self.queue_free()

func _on_timer_timeout():
	makePath()


func _on_attack_time_timeout():
	canAttack = true
