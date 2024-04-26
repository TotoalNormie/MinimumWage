extends Area2D

var bullet_scene = preload("res://CustomComponents/weapons/bullet.tscn")

@export var damage: float = 0.5
@export var speed = 1500
@export var shootingDelay = 0.5
@export_enum('gun', 'closeCombat') var weaponType = 'gun'
var canShoot = true

@onready var sprite = $shape/Sprite2D
@onready var joystick = $"../UI/mobile/joystick"
var joystickAngle = 0

@export_global_file('*.png','*.webp') var sprite_texture_path: String = 'res://Sprites/weapons/glock/New_Piskel.png'

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_ShootingDelayTimeout)
	if sprite_texture_path != "":
		var texture = load(sprite_texture_path)
		if texture != null:
			$shape/Sprite2D.texture = texture
	print($"../UI/mobile")

func _process(delta):
	if $"..".name == "Player" and %UI/mobile.visible:
		print(joystick.posVector.length())
		var angle
		# Calculate the angle based on the joystick's position vector
		if joystick.posVector.length() < 0.1 :
			angle = joystickAngle
		else:
			angle = atan2(joystick.posVector.y, joystick.posVector.x)
			joystickAngle = angle
		
		#print(angle)
		# Convert radians to degrees
		rotation = angle
		# Rotate the gun sprite

	else:
		# Rotate the gun towards the mouse position
		look_at(get_global_mouse_position())

	# Adjust sprite orientation
	var deg = fmod(rotation_degrees, 360)
	if abs(deg) > 90 and abs(deg) < 270:
		sprite.scale.y = abs(sprite.scale.y) * -1
	else:
		sprite.scale.y = abs(sprite.scale.y)
	if OS.has_feature('mobile'):
		if Input.is_action_pressed('shoot_mobile'):
			attack()
	else:
		if Input.is_action_pressed("shoot") and canShoot:
			attack()
		



func attack():
	if weaponType == 'gun':
		#print('works')
		var bullet = bullet_scene.instantiate()
		get_tree().get_root().get_node('main/game').add_child(bullet)
		#add_child(bullet)
		bullet.start($ShootFrom.global_position, rotation, speed, damage)
		#print(self.position)
		canShoot = false
	else:
		pass
	$Timer.start(shootingDelay)
	
func _on_ShootingDelayTimeout():
	canShoot = true
