extends Control

var itemSlots: int = 6
var activeSlot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var slot = preload("res://CustomComponents/InvSlot.tscn")
	for i in range(itemSlots):
		var slotUi = slot.instantiate()
		slotUi.set_size(Vector2(70, 70)*2.0)
		slotUi.name = "Slot {int}".format({"int": i})
		var button = TouchScreenButton.new()
		button.name = "Slot {int} button".format({"int": i})
		button.shape = RectangleShape2D.new()
		button.shape.size = slotUi.get_size()
		button.action = str("slot", i+1)
		button.position = slotUi.global_position
		#slotUi.size = Vector2(80, 80)
		%InvDisplay.add_child(slotUi)
		#setInactiveSlot(i)
		#slotUi.size = size - Vector2(0, 10)
		slotUi.add_child(button)
		print("slot", i)
	onlySet(0)
	#%InvDisplay.get_parent().print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func hit(health, maxHp):
	%HpBar.max_value = maxHp
	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHp) * health)) + "%[/center]"


func changeActiveSlot(slotId, prevSlot):
	print("Clicked: ", slotId)
	var current = %InvDisplay.get_child(slotId)
	current.set_size(current.size + Vector2(0, 10))
	if slotId != prevSlot:
		print("Active: ", slotId, "Prev: ", prevSlot)
		setInactiveSlot(prevSlot)
	
func onlySet(id):
	var current = %InvDisplay.get_child(id)
	current.set_size(current.size + Vector2(0, 10))
	
	
func setInactiveSlot(slotId):
	var current = %InvDisplay.get_child(slotId)
	if current:
		current.set_size(current.size - Vector2(0, 10))
	
