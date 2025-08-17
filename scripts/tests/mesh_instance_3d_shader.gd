extends MeshInstance3D

var progress = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	progress += delta * 0.2  # Adjust speed
	if progress > 1.0:
		progress = 0.0
	material_override.set_shader_parameter("progress", progress)
	pass
