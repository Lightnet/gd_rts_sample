extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var unit_data:UnitData
@export var team_id:int = 0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCEL = 10
const ROTATION_SPEED = 5.0  # Controls how fast the character rotates (adjust as needed)

@export var target:Node3D
@export var target_position:Vector3
var distance_threshold = 1.1  # Stop when this close to the target (in units)
@export var is_follow:bool = false

func _ready() -> void:
	if not unit_data:
		unit_data = UnitData.new()
	#pass

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
		direction.y = 0
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		#velocity.y = 0
		
		# Apply gravity if not on the floor
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		move_and_slide()
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			#print("I collided with ", collision.get_collider().name)
			var unit:Node3D = collision.get_collider()
			if unit.is_in_group("building"):
				#is_follow = false
				#print("found")
				#print("stop")
				pass
		# Calculate distance to the target
		var distance = global_position.distance_to(target_position)
		#print("distance:", distance)
		# Check if close enough to the target
		if distance < distance_threshold:
			is_follow = false
			#print("target_position stop")
			#pass
	#pass

func request_follow_target(pos:Vector3) -> void:
	
	if unit_data:
		var is_found:bool = false
		#unit_data.team_id 
		var players = GameNetwork.players
		for i in players:
			#print("follow player: ",i)
			#if players[i]["team_id"] == unit_data.team_id:
			if players[i]["team_id"] == team_id:
				#print("player id:", i)
				if i == multiplayer.get_unique_id():
					is_found=true
					break
					#pass
			#pass
		#pass
	
		if is_found:
			if multiplayer.is_server():
				set_follow_target.rpc(pos)
			else:
				remote_follow_target.rpc_id(1, pos)
			pass

@rpc("any_peer","call_remote")
func remote_follow_target(pos:Vector3)-> void:
	if not multiplayer.is_server(): return
	
	var is_found:bool = false
	var players = GameNetwork.players
	for i in players:
		if players[i]["team_id"] == team_id:
			if i == multiplayer.get_remote_sender_id():
				is_found=true
				break
	if is_found:
		set_follow_target.rpc(pos)
	
	#need to check for client to move this unit.
	#if unit_data:
		#var is_found:bool = false
		#var players = GameNetwork.players
		#for i in players:
			#if players[i]["team_id"] == team_id:
				#if i == multiplayer.get_remote_sender_id():
					#is_found=true
					#break
		#if is_found:
			#set_follow_target.rpc(pos)

@rpc("authority","call_local")
func set_follow_target(pos:Vector3)-> void:
	target_position = pos
	is_follow = true

func get_team_id()->int:
	return team_id

func request_set_team_id(_id:int)-> void:
	if multiplayer.is_server():
		set_team_id.rpc(_id)
	else:
		remote_set_team_id.rpc_id(1,_id)
		
@rpc("any_peer","call_remote")
func remote_set_team_id(_id:int)-> void:
	set_team_id.rpc(_id)
	
@rpc("authority","call_local")
func set_team_id(_id:int)-> void:
	team_id = _id
