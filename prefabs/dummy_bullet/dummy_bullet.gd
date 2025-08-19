extends Area3D

@export var SPEED:float = 5.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Move the bullet forward (negative Z-axis) based on SPEED and delta time
	translate(Vector3.FORWARD * SPEED * delta)
	#pass
