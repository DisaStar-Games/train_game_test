extends CanvasLayer

@export var chaser: Node
@export var station: Node
@onready var panel: Control = $Panel
@onready var result_label: Label = $Panel/VBoxContainer/ResultLabel
@onready var restart_button: Button = $Panel/VBoxContainer/RestartButton

var _ended := false

func _ready():
	panel.visible = false
	chaser.caught_player.connect(func(): end_game(false))
	station.train_arrived.connect(func(): end_game(true))
	restart_button.pressed.connect(_on_restart)

func end_game(won: bool):
	if _ended:
		return   
	_ended = true
	result_label.text = "YOU WON" if won else "YOU DIED"
	panel.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_restart():
	get_tree().paused = false
	get_tree().reload_current_scene()
