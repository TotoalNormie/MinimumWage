extends CharacterBody2D

@export var health: float = 4
@export var speed = 0
@export var damage = 1
@export var attackRange = 40
@onready var player = $"../%Player"
@onready var navAgent := $NavigationAgent2D

var angleConeOfVision := deg_to_rad(90.0)
var maxViewDistance := 150
var angleBetweenRays := deg_to_rad(5.0)

var items = [
	preload("res://CustomComponents/powerup/health.tscn")
]

var target: String
var navigaionTarget
var doesSeePlayer = false

var canAttack = true
var spawnPoint: Vector2
var goToPoint: Vector2
var rotationSpeed := 3.0
var isLookingAround = false

const type = 'enemy'

func _ready():
	$Node2D/Label.text = str(health)
	generateRaycast()
	
func _physics_process(delta: float) -> void:
	var nextPosition = navAgent.get_next_path_position()
	var dir = to_local(nextPosition).normalized()
	for ray in $Weapon/Rays.get_children():
		if ray.is_colliding() and ray.get_collider().name == "Player":
			startSeesPlayerTimer()
			break
	$Exclamation.visible = false
	rotateToTarget(dir, delta)
	var intendedVelocity = speed * dir
	if doesSeePlayer:
		intendedVelocity = speed * 1.6 * dir
		$Exclamation.visible = true
		
	navAgent.set_velocity(intendedVelocity)

func lookAround():
	isLookingAround = true
	$LookAround.start()
	

func start(_spawnPoint, _goToPoint):
	spawnPoint = _spawnPoint
	goToPoint = _goToPoint
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
		lookAround()
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



func rotateToTarget(target, delta):
	var angleTo = $Weapon.transform.x.angle_to(target)
	$Weapon.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))

func hit(amount):
	health -= amount
	startSeesPlayerTimer()
	
	$Node2D/Label.text = str(health)
	
	if(health <= 0):
		var rnd = RandomNumberGenerator.new()
		var doesDrop = rnd.randf() > 0.5
		if doesDrop:
			var item = items.pick_random().instantiate()
			item.scale = Vector2(0.4, 0.4)
			item.global_position = global_position
			item.player = get_parent().get_node("%Player")
			get_parent().add_child(item)
		queue_free()

func startSeesPlayerTimer():
	doesSeePlayer = true
	$seesPlayer.start()

func _on_timer_timeout():
	makePath()


func _on_attack_time_timeout():
	canAttack = true


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if global_position.distance_to(player.global_position) <= attackRange and doesSeePlayer:
		velocity = Vector2.ZERO
		if canAttack: 
			$Weapon.attack(damage)
			canAttack = false
			$AttackTime.start()
			
	
	if $Weapon.isAttacking or $Weapon.isCharging or !navAgent.is_target_reachable() or isLookingAround:
		velocity = Vector2.ZERO

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
	if abs(rad_to_deg(safe_velocity.angle())) > 95 and abs(rad_to_deg(safe_velocity.angle())) < 275:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * 1
	else:
		$AnimatedSprite2D.scale.x = abs($AnimatedSprite2D.scale.x) * -1
	move_and_slide()


func _on_sees_player_timeout():
	doesSeePlayer = false


func _on_look_around_timeout():
	isLookingAround = false
