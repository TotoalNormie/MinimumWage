extends Panel

var player
var root
var shop
@export var prices: Array = [15, 5, 3]
var used: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.get_parent().get_parent():
		player = self.get_parent().get_parent().get_parent().get_node("Player")
		root = self.get_parent().get_parent().get_parent()
		shop = self.get_parent().get_parent()
		#print("shop: ", self.get_parent().get_parent())


func addMaxHp(amnt, cost):
	if player.money >= cost && !used:
		player.money -= cost
		player.maxHealth += amnt
		print("Added MaxHp \n MaxHp: ", player.maxHealth)
		root.remove_child(shop)
		used = true
	
	
func healHp(percent, cost):
	if  player.money >= cost && player.health * percent > player.maxHealth && !used:
		player.money -= cost
		print("Healed 25%")
		player.health = player.maxHealth
		root.remove_child(shop)
		used = true
	else:
		if player.money >= cost && !used:
			player.money -= cost
			print("Healed 25%")
			player.health *= percent
			root.remove_child(shop)
			used = true


func addSpeed(amnt, cost):
	if player.money >= cost && !used:
		player.money -= cost
		player.speed  *= amnt
		print("Added 3% speed \n ", player.speed)
		root.remove_child(shop)
		used = true


func _on_button_pressed():
	#print(self.name)
	if self.name == "shopSlot 0":
		addMaxHp(2, prices[0])
	if self.name == "shopSlot 1":
		healHp(1.25, prices[1])
	if self.name == "shopSlot 2":
		addSpeed(1.03, prices[2])
	#print("Button Pressed!")
