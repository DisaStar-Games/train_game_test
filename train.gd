extends AnimatableBody3D

signal fuel_changed(current, maximum)

@export var track: Path3D
@export var throttle_button: TrainButton
@export var brake_button: TrainButton
@export var max_speed := 20.0
@export var acceleration := 4.0
@export var brake_strength := 8.0
@export var coast_deceleration := 1.0
@export var max_fuel := 100.0
@export var fuel_use_rate := 2.0   

var fuel := 100.0
var current_speed := 0.0
var throttle_on := false
var brake_on := false
var follower := PathFollow3D.new()


func _ready():
	if track == null:
		push_error("Train: 'track' is not assigned in the inspector.")
		set_physics_process(false)
		return
	track.add_child.call_deferred(follower)
	follower.rotation_mode = PathFollow3D.ROTATION_ORIENTED
	follower.use_model_front = true
	throttle_button.toggled.connect(func(on): throttle_on = on)
	brake_button.toggled.connect(func(on): brake_on = on)
	fuel_changed.emit(fuel, max_fuel)
	add_to_group("train")

func _physics_process(delta):
	if not follower.is_inside_tree():
		return
	if fuel <= 0.0 and throttle_on:
		throttle_button.set_state(false)

	if brake_on:
		current_speed = move_toward(current_speed, 0.0, brake_strength * delta)
	elif throttle_on:
		current_speed = move_toward(current_speed, max_speed, acceleration * delta)
		fuel = max(fuel - fuel_use_rate * delta, 0.0)
		fuel_changed.emit(fuel, max_fuel)
	else:
		current_speed = move_toward(current_speed, 0.0, coast_deceleration * delta)

	follower.progress += current_speed * delta
	global_transform = follower.global_transform
	


func add_fuel(amount: float):
	fuel = min(fuel + amount, max_fuel)
	fuel_changed.emit(fuel, max_fuel)
