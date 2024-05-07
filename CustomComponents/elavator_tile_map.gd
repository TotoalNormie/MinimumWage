extends TileMap

var canInteract = false
var start = false
#var buttonTween: Tween
var canvasTween: Tween
var elevatorDoors = Vector2.ZERO

signal on_level_complete
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(tile_set.get_pattern(7))
	#set_pattern(0, Vector2i(0, 0), tile_set.get_pattern(0))
	generateLevel()

func _process(delta):
	#print(start)
	if canInteract:
		#if buttonTween:
			#buttonTween.kill()
		#buttonTween = create_tween()
		#buttonTween.tween_property($Button, 'visibile', 1, 0.5)
		$Button.visible = 1
	else:
		#if buttonTween:
			#buttonTween.kill()
		#buttonTween = create_tween()
		#buttonTween.tween_property($Button, 'visibile', 0, 0.5)
		$Button.visible = 0
	
	if Input.is_action_pressed('interact'):
		#print('e pressed')
		$Button.emit_signal('pressed')
	if start:
		#if canvasTween:
			#canvasTween.kill()
		#canvasTween = create_tween()
		#var modulate_color : Color
		#modulate_color.r = 255 # RGB is the color
		#modulate_color.g = 255
		#modulate_color.b = 255
		#modulate_color.a = 0 # A is alpha aka transparency
		#canvasTween.tween_property($Sprite2D, 'modulate', modulate_color, 1)
		
		$CanvasModulate.visible = 0
		set_cell(0, Vector2i(8, 4), 9, Vector2i(0, 0))
	else:
		$CanvasModulate.visible = 1
		set_cell(0, Vector2i(8, 4), 8, Vector2i(0, 0))
		
		#if canvasTween:
			#canvasTween.kill()
		#canvasTween = create_tween()
		#var modulate_color : Color
		#modulate_color.r = 255 # RGB is the color
		#modulate_color.g = 255
		#modulate_color.b = 255
		#modulate_color.a = 255 # A is alpha aka transparency
		#canvasTween.tween_property($Sprite2D, 'modulate', modulate_color, 1)
		
	

func generateLevel():
	var elevatorWalls = tile_set.get_pattern(6)
	var elevatorFloor = tile_set.get_pattern(7)
	#var floor = tile_set.get_pattern(8)
	#var middle = tile_set.get_pattern(3)
	#var elevatorOffset = 5
	#var roomLength = 16
	#var middlePoint = roomLength / 2
	
	#for row in 3:
		#for col in 3:
			#var roomId
			#if row == 1 and col == 1:
				#roomId = 3
			#else:
				#var rng = RandomNumberGenerator.new()
				#roomId = rng.randi_range(0, 4)
				#if roomId == 3: 
					#roomId += 1
			#
			##print(row, col, Vector2i(roomLength * col, roomLength * row + elevatorOffset))\
			#var RoomCords = Vector2i(roomLength * col, roomLength * row + elevatorOffset)
			#set_pattern(0, RoomCords, tile_set.get_pattern(roomId))
			#set_pattern(1, RoomCords, floor)
			#if row == 0 and col != 0:
				#set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y), 1, Vector2i(1, 0))
			#elif row == 2:
				#set_cell(0, Vector2i(RoomCords.x + middlePoint, RoomCords.y + roomLength), 1, Vector2i(1, 0))
		#
		#set_cell(0, Vector2i(0, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))
		#set_cell(0, Vector2i(roomLength * 3, roomLength * row + middlePoint + elevatorOffset), 1, Vector2i(1, 0))

	set_pattern(1, Vector2i(6, 0), elevatorFloor)
	set_pattern(0, Vector2i(6, 0), elevatorWalls)
	


func _on_area_2d_body_entered(body):
	print("body entered")
	if !canInteract:
		on_level_complete.emit()
		#print(canInteract)d
	canInteract = true
	start = false


func _on_area_2d_body_exited(body):
	canInteract = false
	

func _on_button_pressed():
	start = true
