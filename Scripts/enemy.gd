extends CharacterBody2D

@export var health: float = 4
@export var speed = 0
@export var damage = 1
@export var attackRange = 32
@onready var player = $"../%Player"
@onready var navAgent := $NavigationAgent2D

var angleConeOfVision := deg_to_rad(90.0)
var maxViewDistance := 150
var angleBetweenRays := deg_to_rad(5.0)

var target: String
var navigaionTarget
var doesSeePlayer = false

var canAttack = true
var spawnPoint: Vector2
var goToPoint: Vector2
var rotationSpeed := 3.0

const type = 'enemy'

func _ready():
	$Node2D/Label.text = str(health)
	generateRaycast()
	
func _physics_process(delta: float) -> void:
	var nextPosition = navAgent.get_next_path_position()
	var dir = to_local(nextPosition).normalized()
	doesSeePlayer = false
	for ray in $Weapon/Rays.get_children():
		#if ray.is_colliding(): 
			#print(ray.get_collider().name)
		if ray.is_colliding() and ray.get_collider().name == "Player":
			doesSeePlayer = true
			break

	#$Weapon.look_at(navAgent.get_next_path_position())
	rotateToTarget(dir, delta)
	
	var intendedVelocity = speed * dir
	navAgent.set_velocity(intendedVelocity)
	#velocity = Vector2.ZERO
	#print(navAgent.get_next_path_position(), " ", navAgent.get_next_path_position() )
	#print(canAttack)

func start(_spawnPoint, _goToPoint):
	spawnPoint = _spawnPoint
	goToPoint = _goToPoint
	#print(goToPoint)
	global_position = spawnPoint
	makePath()

func generateRaycast() -> void:
	var rayCount := angleConeOfVision / angleBetweenRays
	
	for index in rayCount:
		var ray := RayCast2D.new()
		var angle := angleBetweenRays * (index - rayCount / 2.00)
		ray.target_position = Vector2.RIGHT.rotated(angle) * maxViewDistance
		$Weapon/Rays.add_child(ray)
		ray.enabled = true

func makePath() -> void:
	if navAgent.is_target_reached():
		if target == 'goToPoint':
			navAgent.target_position = spawnPoint
			target = 'spawnPoint'
		else:
			navAgent.target_position = goToPoint
			target = 'goToPoint'
	else:
		if target == 'goToPoint':
			target = 'goToPoint'
			navAgent.target_position = goToPoint
		else:
			target = 'spawnPoint'
			navAgent.target_position = spawnPoint
	if doesSeePlayer:
		target = 'player'
		navAgent.target_position = player.global_position
	elif target == 'player':
		target = 'spawnPoint'
		navAgent.target_position = spawnPoint
	#print(navAgent.is_navigation_finished())
	#print(target, " ", navAgent.is_navigation_finished())



func rotateToTarget(target, delta):
	var angleTo = $Weapon.transform.x.angle_to(target)
	$Weapon.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))

func hit(amount):
	health -= amount
	$Node2D/Label.text = str(health)
	
	if(health <= 0):
		self.queue_free()

func _on_timer_timeout():
	makePath()


func _on_attack_time_timeout():
	canAttack = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if global_position.distance_to(player.global_position) <= attackRange:
		velocity = Vector2.ZERO
		if canAttack: 
			$Weapon.attack(damage)
			canAttack = false
			$AttackTime.start()
			
	else:
		$AttackTime.stop()
	
	if $Weapon.isAttacking or $Weapon.isCharging or !navAgent.is_target_reachable():
		velocity = Vector2.ZERO
	#print(velocity)

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
	if abs(rad_to_deg(safe_velocity.angle())) > 95 and abs(rad_to_deg(safe_velocity.angle())) < 275:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * 1
	else:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * -1
	#print(velocity)
	move_and_slide()
