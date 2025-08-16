extends Node3D

# to test spawn for multiplayer

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Marker3D = $SpawnPoint

func _ready() -> void:
	Console.add_command("spawn",cmd_spawn)
	#pass

func _exit_tree() -> void:
	Console.remove_command("spawn")

@rpc("any_peer","call_local")
func request_spawn():
	if multiplayer.is_server():
		spawn_entity.rpc(multiplayer.get_unique_id())
	else:
		request_remote_spawn.rpc_id(1)
	
@rpc("any_peer","call_local")
func request_remote_spawn():
	#this check if this remote id for client
	spawn_entity.rpc(multiplayer.get_remote_sender_id())

@rpc("authority","call_local")
func spawn_entity(pid:int):
	var dummy = DUMMY_UNIT.instantiate()
	print("spawn peer_id: ", pid)
	dummy.set_multiplayer_authority(pid)
	get_tree().current_scene.add_child(dummy)
	dummy.global_position = spawn_point.global_position
	
# test 
func cmd_spawn():
	request_spawn()
