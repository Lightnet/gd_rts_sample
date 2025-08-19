extends CharacterBody3D
#test projectile
@export var team_id:int = 2

@export var health:float = 10
@export var health_max:float = 10

#func _ready() -> void:
	#pass

#func _process(delta: float) -> void:
	#pass

func request_receive_hit(amount:float)->void:
	if multiplayer.is_server():
		receive_hit.rpc(amount)
	else:
		remote_receive_hit.rpc_id(1, amount)
	#pass

@rpc("any_peer","call_remote")
func remote_receive_hit(amount:float)->void:
	receive_hit.rpc(amount)
	#pass
@rpc("authority","call_local")
func receive_hit(_amount:float)->void:
	health -= _amount
	print("health: ", health)
	if health <= 0:
		#request_delete()#nope, error on get_node: not found
		#need to make sure auth and peers. but sfx vfx effect?
		if multiplayer.is_server():
			delete_node.rpc()
		pass
	#pass

func request_delete()->void:
	if multiplayer.is_server():
		delete_node.rpc()
	else:
		remote_delete_node.rpc_id(1)
	#pass
	
@rpc("any_peer","call_remote")
func remote_delete_node()->void:
	delete_node.rpc()
	#pass
	
@rpc("authority","call_local")
func delete_node()->void:
	queue_free()
	#pass
