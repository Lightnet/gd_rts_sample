extends Node

const DUMMY_PLACE_HOLDER = preload("res://prefabs/dummy_place_holder/dummy_place_holder.tscn")
const DUMMY_BUILDING = preload("res://prefabs/dummy_building/dummy_building.tscn")

@export var camera:Camera3D
@export var place_position:Vector3

var is_build:bool = false
var place_holder

func _enter_tree() -> void:
	
	pass
	
func _ready() -> void:
	place_holder = DUMMY_PLACE_HOLDER.instantiate()
	get_tree().current_scene.call_deferred("add_child",place_holder)
	#pass

func _unhandled_input(event: InputEvent) -> void:
	#print("hello")
	if event.is_action_pressed("build"):
		is_build = not is_build
		print("is_build: ", is_build)
		if is_build:
			place_holder.show()
		else:
			place_holder.hide()
		#pass
	if is_build:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					print("Left button was clicked")
					request_build()
		pass
	pass

func _process(delta: float) -> void:
	if is_build:
		update_place_holder()
	pass
	
func update_place_holder():
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_direction: Vector3 = camera.project_ray_normal(mouse_pos)
	var ray_length: float = 1000.0
	var ray_end: Vector3 = ray_origin + ray_direction * ray_length
	
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collision_point: Vector3 = result.position
		var collider: Node = result.collider
		#print("Hit at: ", collision_point, " on object: ", collider.name)
		place_position = collision_point
		if place_holder:
			place_holder.global_position = collision_point
			
	else:
		#print("No collision detected")
		pass
		
	#pass

func request_build():
	if multiplayer.is_server():
		build_building_unit.rpc(place_position)
	else:
		remote_build.rpc_id(1,place_position)
	pass
	
@rpc("any_peer","call_remote")
func remote_build(pos:Vector3):
	build_building_unit.rpc(pos)
	#pass
@rpc("authority","call_local")
func build_building_unit(pos):
	var dummy = DUMMY_BUILDING.instantiate()
	#get_tree().current_scene.call_deferred("add_child", dummy)
	get_tree().current_scene.get_node("NavigationRegion3D").add_child(dummy)
	dummy.global_position = pos
	
	# need to rebake nav mesh
	var nav = get_tree().get_first_node_in_group("navmesh")
	print(nav)
	if nav.has_method("request_bake_nav"):
		nav.request_bake_nav()
	
	#pass
