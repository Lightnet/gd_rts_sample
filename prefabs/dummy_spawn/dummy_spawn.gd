extends Node3D

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Marker3D = $SpawnPoint

func _ready() -> void:
	Console.add_command("spawn",cmd_spawn)
	pass

func _exit_tree() -> void:
	Console.remove_command("spawn")

#func _process(delta: float) -> void:
	#pass

func spawn_entity():
	var dummy = DUMMY_UNIT.instantiate()
	get_tree().current_scene.add_child(dummy)
	dummy.global_position = spawn_point.global_position
	#pass
# test 
func cmd_spawn():
	spawn_entity()
	#pass
