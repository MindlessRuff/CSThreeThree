extends CharacterBody2D

@export var movement_speed = 300.0
@onready var navigation_agent_2d = $NavigationAgent2D

var next_path_position: Vector2
var facing_direction: int
var last_direction = 0

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(Callable(_on_velocity_computed))
	set_facing_direction(Vector2.ZERO)

func set_movement_target(movement_target: Vector2):
	navigation_agent_2d.set_target_position(movement_target)

func set_facing_direction(direction: Vector2) -> int:
	if direction.length_squared() < 0.01:
		return last_direction
		
	var angle = direction.normalized().angle() + (PI / 8.0) / 2.0
	angle = wrapf(angle, 0.0, TAU)
	
	var slice = int(angle / (PI / 4.0))
	
	var iso_index = (slice + 1) % 8
	last_direction = iso_index
	
	return iso_index
	
func _physics_process(_delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navigation_agent_2d.get_navigation_map()) == 0:
		return
	if navigation_agent_2d.is_navigation_finished():
		return

	next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	facing_direction = set_facing_direction(safe_velocity)
