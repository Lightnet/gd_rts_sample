extends Camera3D

@export var target: Node3D
@export var unit: Node3D
@export var units: Array[Node3D] = []

# Camera movement parameters
@export var move_speed: float = 20.0
@export var zoom_speed: float = 10.0
@export var min_zoom: float = 5.0
@export var max_zoom: float = 50.0

@export var is_edge_border:bool = false
@export var edge_border: float = 10.0  # Pixels from edge for screen-edge panning
@export var rotation_speed: float = 2.0

# Internal variables
var _is_rotating: bool = false
var _last_mouse_position: Vector2

func _unhandled_input(event: InputEvent) -> void:
	# Handle mouse button clicks for unit selection/movement
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				_handle_select_unit()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				_handle_move_click()
				_is_rotating = true
				_last_mouse_position = get_viewport().get_mouse_position()
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_zoom(-zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_zoom(zoom_speed)
	
	# Handle rotation release
	if event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_is_rotating = false
	
	# Handle rotation movement
	if event is InputEventMouseMotion and _is_rotating:
		var mouse_delta = get_viewport().get_mouse_position() - _last_mouse_position
		_rotate_camera(mouse_delta)
		_last_mouse_position = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	var movement = Vector3.ZERO
	
	# WASD movement
	if Input.is_action_pressed("forward"):
		movement.z -= 1
	if Input.is_action_pressed("backward"):
		movement.z += 1
	if Input.is_action_pressed("left"):
		movement.x -= 1
	if Input.is_action_pressed("right"):
		movement.x += 1
	
	# Screen edge panning
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var viewport_size = viewport.size
	
	if is_edge_border:
		if mouse_pos.x < edge_border:
			movement.x -= 1
		elif mouse_pos.x > viewport_size.x - edge_border:
			movement.x += 1
		if mouse_pos.y < edge_border:
			movement.z -= 1
		elif mouse_pos.y > viewport_size.y - edge_border:
			movement.z += 1
	
	# Normalize and apply movement
	if movement.length() > 0:
		movement = movement.normalized() * move_speed * delta
		# Move in the camera's local space
		var global_movement = global_transform.basis * movement
		# Keep y constant to avoid flying
		global_movement.y = 0
		global_position += global_movement

#moving unit?
func _handle_select_unit()->void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_direction: Vector3 = project_ray_normal(mouse_pos)
	var ray_length: float = 1000.0
	var ray_end: Vector3 = ray_origin + ray_direction * ray_length
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collision_point: Vector3 = result.position
		var collider: Node = result.collider
		print("Hit at: ", collision_point, " on object: ", collider.name)
		
		if collider:
			#unit.target_position = collision_point
			#if unit.has_method("set_follow_target"):
				#unit.set_follow_target(collision_point)
				
			if collider.is_in_group("unit"):
				print("found unit")
				unit = collider
				pass
			else:
				unit=null
			pass
		if target:
			target.global_position = collision_point
	else:
		unit=null
		print("Deselect Unit")
	pass

func _handle_move_click() -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_direction: Vector3 = project_ray_normal(mouse_pos)
	var ray_length: float = 1000.0
	var ray_end: Vector3 = ray_origin + ray_direction * ray_length
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collision_point: Vector3 = result.position
		var collider: Node = result.collider
		print("Hit at: ", collision_point, " on object: ", collider.name)
		
		if unit:
			#unit.target_position = collision_point
			if unit.has_method("set_follow_target"):
				unit.set_follow_target(collision_point)
			pass
		if target:
			target.global_position = collision_point
	else:
		print("No collision detected")

func _zoom(amount: float) -> void:
	var new_pos = position + (transform.basis.z * amount)
	# Clamp zoom distance
	new_pos.y = clamp(new_pos.y, min_zoom, max_zoom)
	position = new_pos

func _rotate_camera(mouse_delta: Vector2) -> void:
	# Rotate around Y axis (yaw)
	var yaw = -mouse_delta.x * rotation_speed * get_process_delta_time()
	rotate_y(yaw)
	
	# Optional: Rotate around X axis (pitch)
	# var pitch = -mouse_delta.y * rotation_speed * get_process_delta_time()
	# rotate_object_local(Vector3.RIGHT, pitch)
	# Constrain pitch to avoid flipping
	# rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _ready() -> void:
	# Ensure camera is set up
	set_process_unhandled_input(true)
