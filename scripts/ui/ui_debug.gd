extends Control

@onready var label_network: Label = $VBoxContainer/HBoxContainer/Label2
@onready var label_playername: Label = $VBoxContainer/HBoxContainer2/Label2

#func _ready() -> void:
	
	#pass

#func _process(delta: float) -> void:
	
	#pass

func set_network_type():
	label_playername.text = GameNetwork.player_info["name"]
	if multiplayer.is_server():
		label_network.text = "SERVER"
	else:
		label_network.text = "CLIENT"
	#pass
