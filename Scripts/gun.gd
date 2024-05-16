extends Area2D

var bullet_scene = preload("res://CustomComponents/weapons/bullet.tscn")

@export var damage: float = 0.5
@export var speed = 100
@export var shootingDelay = 0.7
@export_enum('gun', 'closeCombat') var weaponType = 'gun'
var canShoot = true
var tween: Tween

@onready var sprite = $shape/Sprite2D
@onready var joystick = $"../%joystick"
var joystickAngle = 0

@export_global_file('*.png','*.webp') var sprite_texture_path: String = 'res://Sprites/weapons/glock/New_Piskel.png'

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_ShootingDelayTimeout)
	if sprite_texture_path != "":
		var texture = load(sprite_texture_path)
		if texture != null:
			$shape/Sprite2D.texture = texture


func _process(delta):
	if $"..".name == "Player" and OS.has_feature("mobile"):
		var angle
		# Calculate the angle based on the joystick's position vector
		if joystick.posVector.length() < 0.1 :
			angle = joystickAngle
		else:
			angle = atan2(joystick.posVector.y, joystick.posVector.x)
			joystickAngle = angle
		
		# Convert radians to degrees
		rotation = angle
		# Rotate the gun sprite

	else:
		# Rotate the gun towards the mouse position
		look_at(get_global_mouse_position())

	# Adjust sprite orientation
	var deg = fmod(rotation_degrees, 360)
	if abs(deg) > 90 and abs(deg) < 270:
		scale.y = abs(scale.y) * -1
	else:
		scale.y = abs(scale.y)
	if Input.is_action_pressed('shoot_mobile') and canShoot:
		attack()
	elif Input.is_action_pressed("shoot") and canShoot and !OS.has_feature("mobile"):
		attack()
		#pass
		



func attack():
	if weaponType == 'gun':
		var rand = RandomNumberGenerator.new()
		var randNum = rand.randf_range(-10, 10)
		var rotationRand = deg_to_rad(rotation_degrees + randNum)
		var bullet = bullet_scene.instantiate()

		get_tree().get_root().add_child(bullet)
		##add_child(bullet)
		bullet.start($ShootFrom.global_position, rotationRand, speed, damage)
		#%MuzzleFlash.emitting = true
		canShoot = false
		recoil()
	else:
		pass
	$Timer.start(shootingDelay)
	$AudioStreamPlayer2D.play()

func recoil():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($shape, "rotation_degrees",  -50, shootingDelay * 0.1)	
	tween.tween_interval(shootingDelay * 0.2)
	tween.tween_property($shape, "rotation_degrees",  0, shootingDelay * 0.7)
	

func _on_ShootingDelayTimeout():
	canShoot = true

