extends TileMap

var canInteract = false
var start = false
var outside = false
var canOpen = false
var levelCompleted = true
var canvasTween: Tween
var elevatorDoors = Vector2.ZERO
var canComplete = false

signal on_level_complete
# Called when the node enters the scene tree for the first time.
func _ready():

	#set_pattern(0, Vector2i(0, 0), tile_set.get_pattern(0))
	generateLevel()
	changeState()

func changeState():
	if start:
		
		if outside and !levelCompleted:
			closeDoors()
		else:
			openDoors()
	
		$CanvasModulate.color = Color(1, 1, 1, 255)

	else:
		closeDoors()
		$CanvasModulate.color = Color(0, 0, 0, 255)
		
func openDoors():
	set_cell(0, Vector2i(8, 4), 9, Vector2i(0, 0))
func closeDoors():
	set_cell(0, Vector2i(8, 4), 8, Vector2i(0, 0))
	

func _process(delta):

	if canInteract:
		%Button.visible = 1
	else:
		%Button.visible = 0
		
	if canOpen and canComplete:
		%ButtonOpen.visible = 1
	else:
		%ButtonOpen.visible = 0
	
	if Input.is_action_just_pressed('interact'):
		if canInteract:
			%Button.emit_signal('pressed')
		elif canOpen and canComplete:

			%ButtonOpen.emit_signal('pressed')
		
	

func generateLevel():
	var elevatorWalls = tile_set.get_pattern(6)
	var elevatorFloor = tile_set.get_pattern(7)

	set_pattern(1, Vector2i(6, 0), elevatorFloor)
	set_pattern(0, Vector2i(6, 0), elevatorWalls)
	


func _on_area_2d_body_entered(body):


	if levelCompleted and !canInteract:
		on_level_complete.emit()

	canInteract = true
	start = false
	levelCompleted = false
	changeState()


func _on_area_2d_body_exited(body):
	canInteract = false
	changeState()
	

func _on_button_pressed():
	start = true
	changeState()



func _on_button_open_pressed():
	levelCompleted = true
	#set_cell(0, Vector2i(8, 4), 9, Vector2i(0, 0))
	changeState()
	
	

func _on_can_open_body_entered(body):
	canOpen = true

func _on_can_open_body_exited(body):
	canOpen = false

func _on_elavator_whole_body_exited(body):
	outside = true
	changeState()

func _on_elavator_whole_body_entered(body):
	outside = false
	changeState()
