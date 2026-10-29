extends CharacterBody3D

signal caught_player

@export var target: Node3D      
@export var base_speed := 10.0            
@export var max_speed := 16.0             
@export var catch_up_distance := 40.0     
@export var gravity := 75.0
@export var turn_speed := 6.0
@onready var agent: NavigationAgent3D = $NavigationAgent3D

var _repath_timer := 0.0

func _ready():
	$KillZone.body_entered.connect(_on_kill_zone_trigger)


func _physics_process(delta):
	if target == null:
		return
	
	_repath_timer -= delta
	if _repath_timer <= 0.0:
		agent.target_position = target.global_position
		_repath_timer = 0.2
	
	var dist := global_position.distance_to(target.global_position)
	
	var speed := lerpf(base_speed, max_speed, clampf(dist / catch_up_distance, 0.0, 1.0))
	
	var dir := Vector3.ZERO
	if not agent.is_navigation_finished():
		dir = agent.get_next_path_position() - global_position
		dir.y = 0.0
		dir = dir.normalized()
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	velocity.y = 0.0 if is_on_floor() else velocity.y - gravity * delta
	
	if dir != Vector3.ZERO:
		rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), turn_speed * delta)
	move_and_slide()


func _on_kill_zone_trigger(body):
	if body.is_in_group("player"):
		caught_player.emit()
