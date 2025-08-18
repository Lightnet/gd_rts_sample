# Multiplayer:
  There are couple of ways to sync. Any Peers and Authority. It depend on the logic functions to call local or remote.

  Any Peer can be good and bad. Depend on the call_remote and call_local for sync.  

  Authority can be server and client when using the remote call. Meaning the cilent has it own Authority assign by the server identity number.
  
  For example private messsage to send correct client id to remote and not to other peers. Reason is simple to prevent cheating or exploit when sync to nodes. Since it peer to peer to for how to handle authority of their own current server and client.
  
  Another is handle duplicate items or create items without limits which should go to server Authority and not any_peer.

  If server for Authority and call_local it will sync with server and clients.

  The reason is that all important logic should be handle on server side to allow client to spawn node unit. In case of hacker exploit some loop hole logic to control spawn which should have conditions. Just spawn endless units. Well it depend on the game logics.

  It come down to permission. 

  To way to check if server.
```
if multiplayer.is_server():
	pass
```
  This to prevent error.

```
	rpc_id("name function", 1, ...args)
	request_remote_spawn.rpc_id(1)
```
  There two way to call rpc for remote.


  This is simple multiplayer to handle sync to all server and client when spawning node.

```
extends Node3D

const DUMMY_UNIT = preload("res://prefabs/dummy_unit/dummy_unit.tscn")
@onready var spawn_point: Marker3D = $SpawnPoint

@rpc("any_peer","call_local")
func request_spawn():
	if multiplayer.is_server():
		spawn_entity.rpc()
	else:
		request_remote_spawn.rpc_id(1)

@rpc("any_peer","call_local")
func request_remote_spawn():
	spawn_entity.rpc()

@rpc("authority","call_local")
func spawn_entity():
	var dummy = DUMMY_UNIT.instantiate()
	get_tree().current_scene.add_child(dummy)
	dummy.global_position = spawn_point.global_position

func cmd_spawn():
	request_spawn()
```
	Note that it is missing the assign authority to node when spawning. This simple test how it works.


```
## server
cmd_spawn > request_spawn > spawn_entity
## client
cmd_spawn > request_remote_spawn > spawn_entity
```
	If the server hosting it would check if this server or client to call functions to match to sync with other peers. It same with the client if not server do request from the server to sync.

```
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
```
	This handle client id. Which later use to assign team unit id tag. Work in progress.
# Notes:
- The project build is subject to change.
- Note if authority override authority will cause error. Just make sure authority and call_local then use call function that has authority and not use request_name use auth local func call.