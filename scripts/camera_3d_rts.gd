extends Camera3D

@export var target:Node3D

@export var unit:Node3D
@export var units:Array[Node3D] = []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			print("click...")
			# Get the mouse position in the viewport
			var mouse_pos: Vector2 = get_viewport().get_mouse_position()
			
			# Get the ray's origin and direction from the camera
			var ray_origin: Vector3 = project_ray_origin(mouse_pos)
			var ray_direction: Vector3 = project_ray_normal(mouse_pos)
			
			# Define the ray's end point (adjust length as needed)
			var ray_length: float = 1000.0
			var ray_end: Vector3 = ray_origin + ray_direction * ray_length
			
			# Perform the raycast
			var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
			var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
			var result: Dictionary = space_state.intersect_ray(query)
			
			# Check if the ray hit something
			if result:
				var collision_point: Vector3 = result.position
				var collider: Node = result.collider
				print("Hit at: ", collision_point, " on object: ", collider.name)
				#Global.target = collision_point
				if unit:
					unit.target_position = collision_point
				if target:
					target.global_position = collision_point
			else:
				print("No collision detected")
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Check for left mouse button click
	pass
