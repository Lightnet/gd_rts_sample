extends StaticBody3D

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Node3D = $SpawnPoint

@export var team_id:int

@export var building_unit:BuildingUnit
@export var time:float = 0.0
@export var time_max:float = 5.0
@export var is_build:bool = false

func _ready() -> void:
	if not building_unit:
		building_unit = BuildingUnit.new()
		building_unit.name = "DummyBuilding"
	#pass
	
func _process(delta: float) -> void:
	
	if is_build:
		time += delta
		#print("team id:", building_unit.team_id )
		if time >= time_max:
			time = 0
			#need to make sure of server or client own in case copies 
			if multiplayer.is_server():
				request_spawn()
			
	pass

func get_building_name()->String:
	return building_unit.name

func request_build():
	if multiplayer.is_server():
		start_build_unit.rpc()
	else:
		remote_start_build.rpc_id(1)
		
func request_stop_build():
	if multiplayer.is_server():
		stop_build_unit.rpc()
	else:
		remote_stop_build.rpc_id(1)
	
@rpc("any_peer","call_remote")
func remote_start_build():
	start_build_unit.rpc()

@rpc("authority","call_local")
func start_build_unit():
	#print("dummy build unit...")
	#print("team id:", building_unit.team_id )
	#push_error("team id:" + str(building_unit.team_id))
	#push_warning("team id:" + str(building_unit.team_id))
	is_build = true
	
@rpc("any_peer","call_remote")
func remote_stop_build():
	stop_build_unit.rpc()
	
@rpc("authority","call_local")
func stop_build_unit():
	print("stop unit...")
	is_build = false
	
func request_spawn():
	if multiplayer.is_server():
		create_unit.rpc()
	else:
		build_spawn.rpc_id(1)
	#pass

@rpc("any_peer","call_remote")
func build_spawn():
	create_unit.rpc()
	#pass

@rpc("authority","call_local")
func create_unit():
	var dummy = DUMMY_UNIT.instantiate()
	get_tree().current_scene.add_child(dummy)
	print("building_unit.team_id: ", building_unit.team_id)
	#dummy.unit_data.team_id = building_unit.team_id
	#dummy.unit_data.team_id = team_id
	dummy.team_id = team_id
	push_error("dummy.unit_data.team_id: " + str(dummy.unit_data.team_id))
	dummy.global_position = spawn_point.global_position
	#pass

#================================================
# DELETE NODE
#================================================
func request_delete():
	if multiplayer.is_server():
		remove_node.rpc()
	else:
		remote_delete.rpc_id(1)
	#pass
@rpc("any_peer","call_remote")
func remote_delete():
	remove_node.rpc()
	#pass
@rpc("authority","call_local")	
func remove_node():
	queue_free()
	#pass
#================================================
# SET TEAM ID
#================================================
func request_set_team_id(_id:int):
	if multiplayer.is_server():
		set_team_id.rpc(_id)
	else:
		set_team_id.rpc_id(1,_id)
	#pass
@rpc("any_peer","call_remote")
func remote_set_team_id(_id:int):
	set_team_id.rpc(_id)
	#pass
@rpc("authority","call_local")
func set_team_id(_id:int):
	push_error("set building team id:" + str(_id))
	#building_unit.team_id = _id
	team_id = _id
	#pass
