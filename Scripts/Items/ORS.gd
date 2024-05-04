extends Node2D

@export var radius: float = 3
@export var atk: float = 2
var canShoot = true
@export var shootingDelay = 0.5
var rng = RandomNumberGenerator.new()
@export var speed = 1500
var bullet_scene = preload("res://CustomComponents/weapons/bullet.tscn")
var bulletStartPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bulletStartPos = self.position
	#pass
	
	
func damage(atk):
	#return atk * rng.randf_range(1.1, 1.4)
	#return round(atk * rng.randf_range(1.1, 1.4))
	return atk*2
		

func use() -> void:
	#print(self.scene_file_path)
	#print("Shooting the ORS")
	attack()
			
			
func attack():
	#if weaponType == 'gun':
	var bullet = bullet_scene.instantiate()
	# adds bullet to scene
	self.add_child(bullet)
	#self.get_parent().get_parent().add_child(bullet)
	#var bulletStartPos = self.get_parent().global_position
	#var bulletStartPos = self.position
	bullet.start(bulletStartPos, rotation, speed, damage(atk))
	canShoot = false
	$Timer.start(shootingDelay)


func _on_timer_timeout():
	canShoot = true
