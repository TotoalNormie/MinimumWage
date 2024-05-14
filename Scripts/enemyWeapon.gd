extends Node2D

var tween
var isAttacking = false
var isCharging = false
var chargeTime = 0.5
var attackTime = 0.3

@onready var damage = $"..".damage

func _ready():
	$isCharging.wait_time = chargeTime
	$isAttacking.wait_time = attackTime


func _process(delta):

	var deg = fmod(rotation_degrees, 360)
	if abs(deg) > 95 and abs(deg) < 275:
		scale.y = abs(scale.y) * -1
	else:
		scale.y = abs(scale.y)


func attack(damage):
	if tween:
		tween.kill()
		
	$isCharging.start()
	isCharging = true
	tween = create_tween()
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  -30, chargeTime)	
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  120, attackTime)
	tween.tween_interval(0.5)
	tween.tween_property($Area2D/CollisionShape2D, "rotation_degrees",  0, 0.7)
	

func _on_is_charging_timeout():
	$isAttacking.start()
	$isCharging.stop()
	
	isCharging = false
	isAttacking = true

func _on_is_attacking_timeout():
	isAttacking = false
	$isAttacking.stop()
	

func _on_area_2d_body_entered(body):
	if body.name == 'Player' and isAttacking:
		body.hit(damage)

