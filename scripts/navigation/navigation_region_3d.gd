extends NavigationRegion3D
# https://www.reddit.com/r/godot/comments/17x3qvx/baking_navmesh_regions_at_runtime_best_practices/#:~:text=I%20searched%20around%20for%20a,built%20in%20NavigationRegion3d%20rebaking%20functionality?&text=NavigationRegion.,a%204%2D5%20second%20interval.

var nav_mesh:NavigationMesh

func _ready() -> void:
	bake_finished.connect(_on_finished)
	pass

#func _process(delta: float) -> void:
	#pass

func _on_finished():
	print("_on_finished baked")

func request_bake_nav():
	if multiplayer.is_server():
		bake_nav.rpc()
	else:
		remote_bake.rpc_id(1)
	pass
	
@rpc("any_peer","call_remote")
func remote_bake():
	bake_nav()
	#pass
	
@rpc("authority","call_local")
func bake_nav():
	#navigation_mesh = NavigationMesh.new()
	## Configure bake settings (optional, adjust as needed)
	#navigation_mesh.cell_size = 0.3
	#navigation_mesh.cell_height = 0.2
	#navigation_mesh.agent_height = 2.0
	#navigation_mesh.agent_radius = 0.5
	#navigation_mesh.max_slope = deg_to_rad(45.0)
	# Bake the navmesh
	bake_navigation_mesh(true)
	await bake_finished
	#var on_thread: bool = true
	#bake_navigation_mesh(on_thread)
	#print("FINISHED")
	pass
