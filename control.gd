extends Control

@export var color := Color.WHITE
@export var radius := 3.0

func _ready():
	custom_minimum_size = Vector2(radius * 2, radius * 2)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw():
	draw_circle(size / 2, radius, color)

func set_highlight(on: bool):
	color = Color.YELLOW if on else Color.WHITE
	radius = 5.0 if on else 3.0
	custom_minimum_size = Vector2(radius * 2, radius * 2)
	queue_redraw()
