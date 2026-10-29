extends CanvasLayer

@export var train: Node
@export var player: Node
@onready var fuel_bar: ProgressBar = $MarginContainer/VBoxContainer/FuelBar
@onready var coal_label: Label = $MarginContainer/CoalContainer/CoalLabel/Label
@onready var crosshair = $CenterContainer/Control

func _ready():
	train.fuel_changed.connect(_on_fuel_changed)
	_on_fuel_changed(train.fuel, train.max_fuel)
	player.looking_at_interactable.connect(crosshair.set_highlight)
	player.coal_changed.connect(_on_coal_changed)   # was missing
	_on_coal_changed(player.coal)                   # show the starting value

func _on_fuel_changed(current, maximum):
	fuel_bar.max_value = maximum
	fuel_bar.value = current

func _on_coal_changed(amount):
	coal_label.text = "Coal: %d / %d" % [amount, player.max_coal]
	coal_label.text = str(amount)
