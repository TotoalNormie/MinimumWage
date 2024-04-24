extends Sprite2D
@onready var joystick = $".."


var pressing = false

@export var deadzone = 5
@onready var radius = $"../CollisionShape2D".shape.radius
@onready var maxLength = radius

func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressing:
		var target_position = get_global_mouse_position()
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

	position = position.limit_length(radius)
	calculateVector()

func calculateVector():
	joystick.posVector = Vector2(0,0)
	if(abs(global_position.x - joystick.global_position.x) >= deadzone):
		joystick.posVector.x = (global_position.x - joystick.global_position.x) / maxLength
	if(abs(global_position.y - joystick.global_position.y) >= deadzone):
		joystick.posVector.y = (global_position. y - joystick.global_position.y) / maxLength


func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false
