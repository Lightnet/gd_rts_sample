extends Control

@onready var ui_network: Control = $"."
@onready var ui_debug: Control = $"../UIDebug"
@onready var line_edit_player_name: LineEdit = $CenterContainer/PanelContainer/VBoxContainer/LineEdit_PlayerName

func _ready() -> void:
	line_edit_player_name.text = Global.generate_random_name()
	pass

func _on_btn_host_pressed() -> void:
	GameNetwork.player_info["name"] = line_edit_player_name.text
	GameNetwork.player_info["team_id"] = 1
	
	GameNetwork._network_host()
	ui_network.hide()
	ui_debug.set_network_type()
	#pass

func _on_btn_join_pressed() -> void:
	GameNetwork.player_info["name"] = line_edit_player_name.text
	GameNetwork.player_info["team_id"] = 2
	
	GameNetwork._network_join()
	ui_network.hide()
	ui_debug.set_network_type()
	#pass
