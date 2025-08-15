extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCEL = 10
const ROTATION_SPEED = 5.0  # Controls how fast the character rotates (adjust as needed)

@export var target:Node3D
@export var target_position:Vector3
var distance_threshold = 1.1  # Stop when this close to the target (in units)
@export var is_follow:bool = false

func _physics_process(delta: float) -> void:
	var direction = Vector3()
	if target_position and is_follow == true:
		nav.target_position = target_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		 # Rotate to face the direction of movement
		if direction.length() > 0:  # Ensure there's a valid direction to rotate toward
			var target_rotation = atan2(direction.x, direction.z)  # Calculate angle in XZ plane
			#print("target_rotation: ", target_rotation)
			target_rotation = target_rotation + deg_to_rad(180) #match face -z direction
			var current_rotation = rotation.y
			# Smoothly interpolate the Y rotation
			rotation.y = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
		
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		move_and_slide()
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			#print("I collided with ", collision.get_collider().name)
			var unit:Node3D = collision.get_collider()
			if unit.is_in_group("building"):
				#is_follow = false
				#print("found")
				print("stop")
				pass
		# Calculate distance to the target
		var distance = global_position.distance_to(target_position)
		#print("distance:", distance)
		# Check if close enough to the target
		if distance < distance_threshold:
			is_follow = false
			print("target_position stop")
			pass
	pass

func set_follow_target(pos:Vector3):
	target_position = pos
	is_follow = true
	#pass
