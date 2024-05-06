extends CharacterBody2D

@export var health: float = 4
@export var speed = 0
@export var damage = 1
@export var attackRange = 16
@onready var player = $"../%Player"
@onready var navAgent := $NavigationAgent2D

var angleConeOfVision := deg_to_rad(40.0)
var maxViewDistance := 100
var angleBetweenRays := deg_to_rad(5.0)
var rays: Array
var target

var canAttack = true
var spawnPoint: Vector2i
var goToPoint: Vector2i

const type = 'enemy'

func _ready():
	$Label.text = str(health)
	generateRaycast()
	
func _physics_process(delta: float) -> void:
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	target = null
	for ray in rays:
		#if ray.is_colliding(): 
			#print(ray.get_collider().name)
		if ray.is_colliding() and ray.get_collider().name == "Player":
			target = player
			break
			
	var doesSeePlayer := target != null
	if doesSeePlayer:
		print('sees player')
	#print(rad_to_deg(dir.angle()))
	velocity = 50 * dir
	#velocity = Vector2.ZERO
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

func generateRaycast() -> void:
	var rayCount := angleConeOfVision / angleBetweenRays
	
	for index in rayCount:
		var ray := RayCast2D.new()
		var angle := angleBetweenRays * (index - rayCount / 2.00)
		ray.target_position = Vector2.UP.rotated(angle) * maxViewDistance
		add_child(ray)
		ray.enabled = true
		rays.append(ray)

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
