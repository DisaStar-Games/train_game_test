class_name TrainButton
extends StaticBody3D

signal toggled(is_on: bool)

var is_on := false

func interact(_player = null):
	set_state(not is_on)

func set_state(value: bool):
	if is_on == value:
		return
	is_on = value
	toggled.emit(is_on)
	position.y += -0.02 if is_on else 0.02
