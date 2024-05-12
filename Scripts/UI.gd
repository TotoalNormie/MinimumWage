extends Control

var itemSlots: int = 4
var activeSlot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().paused:
		%InvDisplay.visible = false
		%HpBar.visible = false
	else:
		%InvDisplay.visible = true
		%HpBar.visible = true
	var slot = preload("res://CustomComponents/InvSlot.tscn")
	for i in range(itemSlots+1):
		var slotUi = slot.instantiate()
		slotUi.name = "Slot {int}".format({"int": i})
		slotUi.set_size(Vector2(50, 50))
		%InvDisplay.add_child(slotUi)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().paused:
		%InvDisplay.visible = false
		%HpBar.visible = false
	else:
		%InvDisplay.visible = true
		%HpBar.visible = true

func hit(health, maxHp):
	%HpBar.max_value = maxHp
	%HpBar.value = health
	%HpVal.text = "[center]" + str(ceil((100/maxHp) * health)) + "%[/center]"

func changeActiveSlot(slotId):
	print(activeSlot)
	var current = %InvDisplay.get_child(slotId)
	current.set_size(current.size + Vector2(0, 10))
	
	
func setInactiveSlot(slotId):
	#print(activeSlot)
	var current = %InvDisplay.get_child(slotId)
	if current:
		current.set_size(current.size - Vector2(0, 10))
	
