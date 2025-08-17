extends Node

@onready var dummy_building_1: StaticBody3D = $"../NavigationRegion3D/DummyBuilding1"
@onready var dummy_building_2: StaticBody3D = $"../NavigationRegion3D/DummyBuilding2"

func _ready() -> void:
	Console.add_command("setteam",cmd_set_team)
	#pass

func _exit_tree() -> void:
	Console.remove_command("setteam")
	#pass

func cmd_set_team():
	request_set_team()
	#pass

func request_set_team():
	if multiplayer.is_server():
		set_team.rpc()
		#pass
	else:
		remote_set_team.rpc_id(1)
		#pass
	#pass
	
@rpc("any_peer","call_remote")
func remote_set_team():
	set_team.rpc()
	#pass

@rpc("authority","call_local")
func set_team():
	print("set team...")
	pass
