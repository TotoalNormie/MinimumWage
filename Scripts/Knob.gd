extends Sprite2D
@onready var joystick = $".."


var pressing = false
var fingerDrag: Vector2

@export var deadzone = 5
@onready var radius = $"../CollisionShape2D".shape.radius
@onready var maxLength = radius

func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventScreenDrag: 
		fingerDrag = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(InputEventScreenDrag.index)
	if pressing and fingerDrag != Vector2.ZERO:
		var target_position = fingerDrag
		var joystick_position = joystick.global_position
		var distance = joystick_position.distance_to(target_position)
		
		if distance <= maxLength:
			global_position = target_position
		else:
			var angle = atan2(target_position.y - joystick_position.y, target_position.x - joystick_position.x)
			global_position.x = joystick_position.x + cos(angle) * maxLength
			global_position.y = joystick_position.y + sin(angle) * maxLength
	else:
		global_position = lerp(global_position, joystick.global_position, delta * 20)
		fingerDrag = joystick.global_position
		

	position = position.limit_length(radius)
	calculateVector()

func calculateVector():
	joystick.posVector = Vector2(0,0)
	if(abs(global_position.x - joystick.global_position.x) >= deadzone):
		joystick.posVector.x = (global_position.x - joystick.global_position.x) / maxLength
	if(abs(global_position.y - joystick.global_position.y) >= deadzone):
		joystick.posVector.y = (global_position. y - joystick.global_position.y) / maxLength

func _on_button_pressed():
	pressing = true


func _on_button_released():
	pressing = false
