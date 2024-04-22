extends Area2D

var bullet_scene = preload("res://CustomComponents/weapons/bullet.tscn")

@export var damage: float = 0.5
@export var speed = 1000
@export var shootingDelay = 0.5
var canShoot = true

@onready var sprite = $shape/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(_on_ShootingDelayTimeout)

func _process(_delta):
	look_at(get_global_mouse_position())
	#$Area2D.rotation += PI
	var deg = fmod(rotation_degrees, 360)
	if(deg > 90 and deg < 270):
		sprite.scale.y = abs(sprite.scale.y) * -1
	else:
		sprite.scale.y = abs(sprite.scale.y)
		
	#print(sprite.scale)
	
	if (Input.is_action_pressed("shoot") and canShoot):
		shoot()
	

func shoot():
	#print('works')
	var bullet = bullet_scene.instantiate()
	get_tree().get_root().get_node('main/game').add_child(bullet)
	#add_child(bullet)
	bullet.start($ShootFrom.global_position, rotation, speed, damage)
	#print(self.position)
	canShoot = false
	$Timer.start(shootingDelay)
	
func _on_ShootingDelayTimeout():
	canShoot = true
