extends StaticBody3D

@export var amount_on_pickup := 1

func interact(player):
	player.add_coal(amount_on_pickup)
