extends CharacterBody3D

signal coal_changed(amount)
signal looking_at_interactable(is_looking: bool)

@export var speed = 14
@export var jump_impulse = 20
@export var fall_acceleration = 75
@export var mouse_sensitivity := 0.003
@export var max_coal := 10
@onready var body_pivot = $Pivot
@onready var camera_pivot = $Pivot/Character/CameraPivot
@onready var interact_ray: RayCast3D = $Pivot/Character/CameraPivot/Camera3D/RayCast3D


var target_velocity = Vector3.ZERO
var coal := 0
var _was_looking:= false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interact_ray.add_exception(self)
	add_to_group("player")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		
		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

func _physics_process(delta):
	var direction = Vector3.ZERO
		
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	var looking:= false
	if interact_ray.is_colliding():
		var target = interact_ray.get_collider()
		looking = target != null and target.has_method("interact")
	
	if looking != _was_looking:
		_was_looking = looking
		looking_at_interactable.emit(looking)
	
	if Input.is_action_just_pressed("interact"):
		interact_ray.force_raycast_update()
		print("Ray hit:", interact_ray.get_collider())
		if interact_ray.is_colliding():
			var target = interact_ray.get_collider()
			if target != null and target.has_method("interact"):
				target.interact(self)
	
	direction = (transform.basis * direction).normalized()
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor():
		target_velocity.y = 0.0
		if Input.is_action_just_pressed("jump"):
			target_velocity.y = jump_impulse
	else:
		target_velocity.y -= fall_acceleration * delta
	
	velocity = target_velocity
	move_and_slide()

func add_coal(amount: int):
	coal = min(coal + amount, max_coal)
	coal_changed.emit(coal)

func take_coal(amount: int):
	if coal< amount:
		return false
	coal -= amount
	coal_changed.emit(coal)
	return true
