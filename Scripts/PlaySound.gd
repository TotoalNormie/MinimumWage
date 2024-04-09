extends Area2D

# Sound Goes here
@export var sound = preload("res://static.wav")
@export var volume: float = 1.0
@export var cutoff: bool = true
#@export vat node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("area_entered", playSound)
	#connect("body_entered", playSound)
	#print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Called when the player enters the Area2D
func playSound() -> void:
	# Get the first Player node in the current scene (using get_node)
	var player = get_node("Player")  # Look for a node named "Player" directly

	if player != null:
		print("Player Detected.")
		# Play the sound
		#$AudioStreamPlayer2D.play(sound)
		
func _on_body_entered(body):
	$AudioStreamPlayer2D2.stream = sound
	$AudioStreamPlayer2D2.play(volume)


func _on_body_exited(body):
	if cutoff:
		$AudioStreamPlayer2D2.stop()
