Savus custom components liekat `CustomAssets` mape.
Ja gribat uztaisit savu custom komponenti tad Right Click `CustomAssets` new scene un Node2D un visu likt zem node 2d.
Lai so assetu pectam izmantotu atver to scene kura tu gribi vinu importet. Right Click uz savu custom component un izvelies instantiate
# Lai skripta deklaretajam mainigajam gribat lai vinu redz editora izmantojiet `@export` direktivu pirms mainiga taja pasa linija piemeram `@export var speed: float = 1.23`

Btw vajag labaku project trukturu ar mapem `Assets` `Scripts` `Sprites`

Player skriptam ir ari inventory ar tipu `dictionary`. Izmanto `dictionary`, jo Mums vajag glabat vel data klat itemam piem durability bullets utt.

ChatSkibiti piemers 
```
var itemData = {
	"name": "Assault Rifle",
	"icon": preload("res://textures/rifle.png"),  # Replace with your icon path
	"quantity": 1,  # Number of rifles in possession
	"ammo": {  # Dictionary for ammo details
		"bullets": 100,
		"magazines": 3
	}
}
```
