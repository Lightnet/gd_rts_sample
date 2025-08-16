extends StaticBody3D

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Node3D = $SpawnPoint

@export var building_unit:BuildingUnit
@export var time:float = 0.0
@export var time_max:float = 5.0
@export var is_build:bool = false

func _ready() -> void:
	building_unit = BuildingUnit.new()
	building_unit.name = "DummyBuilding"
	pass
	
func _process(delta: float) -> void:
	
	if is_build:
		time += delta
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
	pass

func request_stop_build():
	if multiplayer.is_server():
		stop_build_unit.rpc()
	else:
		remote_start_build.rpc_id(1)
	pass
	
@rpc("any_peer","call_remote")
func remote_start_build():
	start_build_unit.rpc()

@rpc("authority","call_local")
func start_build_unit():
	print("build unit...")
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
	pass

@rpc("any_peer","call_remote")
func build_spawn():
	create_unit.rpc()
	pass

@rpc("authority","call_local")
func create_unit():
	var dummy = DUMMY_UNIT.instantiate()
	get_tree().current_scene.add_child(dummy)
	dummy.global_position = spawn_point.global_position
	#pass
