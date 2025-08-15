extends StaticBody3D

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Node3D = $SpawnPoint

var building_unit:BuildingUnit

func _ready() -> void:
	building_unit = BuildingUnit.new()
	building_unit.name = "DummyBuilding"
	pass
	
func _process(delta: float) -> void:
	pass

func get_building_name()->String:
	return building_unit.name

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
