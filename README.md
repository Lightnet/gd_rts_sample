# gd_rts_sample

# Godot Engine: 4.4.1

# License: MIT

# Information:
  Testing godot engine for real time strategy. To see how to set up and simple sample break down for units and buildings.

  Working on keeping it simple to later add on to test the builds.

  Building base, gather resource, melee, range and conditions to win and lose battle.

## Notes:
- Current working on the 3D RTS.
- Note that navigation node classes are flag due to subject to changes.

# Design:
  To keep the  real time strategy simple. Need to build a home base, spawning units and other things.

  Working how to make the multiplayer test sample to work.

# Controls:
- W,A,S,D = move around the camera
- Hold right to rotate camera
- Left Mouse Click = select unit
- Right Mouse Click = move unit
- Select unit to build g key
- Mouse scroll zoom cameera up and down.
- B key = toggle build.

- select building unit = left click
- select unit = left click
	- right click move

# key input:
- [ ] recruit
	- g key
- [ ] build
	- b key
- [ ] train
	- h key
- [ ] sell
	- n key
- [ ] recycle
	- r key
	
	
  Work in progress.

# Features:
- [x] host
- [x] join
- [x] notify message
- [x] sent message test
- [x] dev console / cheat
- [ ] building
	- [x] team id
	- [x] place building
	- [x] delete building
	- [x] select building
	- [x] build unit
	- [x] time build unit
	- [x] building_unit
		- note that sync team_id need to using MultiplayerSynchronizer and not Resource class
		- need to get id checks when selected.
	- [x] NavigationObstacle3D
		- Note rebuild navigation mesh has bugs.
		- Note building must place in NavigationObstacle3D as child
		- Note if fail to parent NavigationObstacle3D which mesh fail to create avoid nav mesh.
		
- [ ] pawn unit
	- [x] team id
	- [x] select move unit
	- [x] spawn unit
	- [x] team unit
	- [x] attack unit (wip)
	- [x] projectile fire
	- [x] health (wip)
	- [x] damage (wip)
- [ ] helper
	- [x] generate name id for sync
		- to deal with out sync name.
## network
- [ ] build base
- [x] select move unit
- [x] ui host and join
- [x] notify message
- [x] chat message
- [ ] game config

  Note this is work in progress.

# Multiplayer:
  Using the server and client for local test build.

  Note that depend how to set the order to make sure they working.

  Created a prefixed name for request and remote for easy naming for their use.

```
@rpc("any_peer","call_local")
func request_spawn():
	if multiplayer.is_server():
		spawn_entity.rpc()
	else:
		request_remote_spawn.rpc_id(1)
@rpc("any_peer","call_local")
func remote_spawn():
	spawn_entity.rpc()
@rpc("authority","call_local")
func spawn_entity():
	var dummy = DUMMY_UNIT.instantiate()
	get_tree().current_scene.add_child(dummy)
	dummy.global_position = spawn_point.global_position
```
  The reason for set up this way to handle server and client checks.

  The example is placing building units.


```
# building_team_mode.gd
@rpc("authority","call_local")
func build_building_unit(team_id:int, pos):
	var dummy = DUMMY_BUILDING.instantiate()
	get_tree().current_scene.get_node("NavigationRegion3D").add_child(dummy)
	#dummy.request_set_team_id(team_id) # do not use while in authority will get error
	dummy.set_team_id(team_id)# since we are in authority use this
	dummy.global_position = pos
	#...
```
  This section deal with section when there server we do not need to request_set_team_id else it would sync error. Use set_team_id since this is server and not client. This prevent client creating building without limits. Just example and notes.

## Notes:
- There will be incorrect error if not set in correct or config in correct.
- there chance the name generate id does or out of sync.
- need to learn about more in depth for is_multiplayer_authority() and set_multiplayer_authority()
- note this may be incorrect code for multiplayer to test sync. It need to be refine.
# Credits:
- Grok
	- From x.com by using reference and help. 
- https://docs.godotengine.org/en/stable/tutorials/physics/using_character_body_2d.html#detecting-collisions
- https://www.youtube.com/watch?v=fS0IhyZrzts
