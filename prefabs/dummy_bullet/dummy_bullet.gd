extends Area3D

@export var SPEED:float = 5.0
@export var team_id:int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Move the bullet forward (negative Z-axis) based on SPEED and delta time
	translate(Vector3.FORWARD * SPEED * delta)
	#pass

func _on_body_entered(body: Node3D) -> void:
	print("bullet body: ", body)
	if body.is_in_group("unit"):
		if body.team_id != team_id:
			queue_free()
	#pass
