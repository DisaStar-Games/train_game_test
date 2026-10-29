extends StaticBody3D

@export var train: Node
@export var fuel_per_coal := 10

func interact(player):
	if train.fuel >= train.max_fuel:
		return
	if player.take_coal(1):
		train.add_fuel(fuel_per_coal)
