extends RigidBody2D

@export var shopSlot: PackedScene
@export var icons: Array[CompressedTexture2D]
@export var description: Array[String]

func _ready():
	%ShopDisplay.visible = false
	for i in range(3):
		var scene = shopSlot.instantiate()
		scene.name = "shopSlot {str}".format({"str": str(i)})
		scene.get_child(0).texture = icons[i]
		scene.get_child(1).text = description[i]
		print(scene.get_child(2).pressed)
		#scene.get_child(2).pressed = addMaxHp(2, prices[i])
		%ShopDisplay.add_child(scene)
		
	#pass

func _physics_process(delta):
	# if touching show message
	# do you want to restore 25% of your hp for 5 coins
	pass
	
#func addMaxHp(amnt, cost):
	#print("Added MaxHp")
	#if player.money >= cost && !used:
		#player.maxHealth += amnt
		#used = true
	#
	#
#func healHp(percent, cost):
	#print("Healed 25%")
	#if  player.money >= cost && player.health * percent > player.maxHealth && !used:
		#player.health = player.maxHealth
		#used = true
	#else:
		#if player.money >= cost:
			#print("Healed 25%")
			#player.health *= percent
			#used = true
#
#
#func addSpeed(amnt, cost):
	#print("Added 3% speed")
	#if player.money >= cost && !used:
		#player.speed  *= amnt
		#used = true


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		%ShopDisplay.visible = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		%ShopDisplay.visible = false
