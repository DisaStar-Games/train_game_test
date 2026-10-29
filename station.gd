extends Area3D

signal train_arrived

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("train"):
		train_arrived.emit()
