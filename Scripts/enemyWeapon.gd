extends Node2D

var tween
var isAttacking = false
var chargeTime = 0.5
var attackTime = 0.3

@onready var damage = $"..".damage
# Called when the node enters the scene tree for the first time.
func _ready():
	$isCharging.wait_time = chargeTime
	$isAttacking.wait_time = attackTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at($"../../../../Player".global_position)
	print(isAttacking)
	var deg = fmod(rotation_degrees, 360)
	if abs(deg) > 90 and abs(deg) < 270:
		scale.y = abs(scale.y) * -1
	else:
		scale.y = abs(scale.y)


func attack(damage):
	if tween:
		tween.kill()
		
	$isCharging.start()
	tween = create_tween()
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  -30, chargeTime)	
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  120, attackTime)
	tween.tween_interval(0.5)
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  0, 0.7)
	

func _on_is_charging_timeout():
	$isAttacking.start()
	$isCharging.stop()
	
	isAttacking = true

func _on_is_attacking_timeout():
	isAttacking = false
	$isAttacking.stop()
	

func _on_area_2d_body_entered(body):
	print(body)
	if body.name == 'Player' and isAttacking:
		body.hit(damage)

