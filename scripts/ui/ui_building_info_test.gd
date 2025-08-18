extends PanelContainer

@onready var label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var label_time: Label = $VBoxContainer/HBoxContainer2/Label2
@onready var label_team_id: Label = $VBoxContainer/HBoxContainer5/Label2

var building_unit:BuildingUnit
var building_node:Node3D

func _ready() -> void:
	
	pass

func _process(_delta: float) -> void:
	if building_node:
		label_time.text = "%.2f" % building_node.time
	#pass

func set_building_node(_node:Node3D)-> void:
	building_node = _node
	set_building_info(_node.building_unit)
	label_team_id.text = str(_node.team_id)
	#pass

func set_building_info(_building_unit:BuildingUnit)-> void:
	building_unit = _building_unit
	label.text = _building_unit.name
	#label_team_id.text = str(_building_unit.team_id)
	#pass

func _on_btn_build_pressed() -> void:
	if building_node:
		if building_node.has_method("request_build"):
			var is_found:bool = false
			#var players = GameNetwork.players
			print("peer id:", multiplayer.get_unique_id())
			var peer_id = multiplayer.get_unique_id()
			if peer_id <= 0:
				return
			Global.notify_message("Current Team ID" + str(GameNetwork.player_info["team_id"]))
			Global.notify_message("Select Building Team ID" + str(building_node.team_id))
			if building_node.team_id == GameNetwork.player_info["team_id"]:
				is_found = true
			else:
				Global.notify_message("Wrong Team Building")
				#pass
			if is_found:
				#print("build unit")
				building_node.request_build()
				#pass
				#push_error("building team_id: " + str(building_node.building_unit.team_id))
	#pass

func _on_btn_stop_pressed() -> void:
	if building_node:
		var is_found:bool = false
		#var players = GameNetwork.players
		print("peer id:", multiplayer.get_unique_id())
		var peer_id = multiplayer.get_unique_id()
		if peer_id <= 0:
			return
		Global.notify_message("Current Team ID" + str(GameNetwork.player_info["team_id"]))
		Global.notify_message("Select Building Team ID" + str(building_node.team_id))
		if building_node.team_id == GameNetwork.player_info["team_id"]:
			is_found = true
		else:
			Global.notify_message("Wrong Team Building")
			pass
			
		if building_node.has_method("request_stop_build") and is_found:
			building_node.request_stop_build()
			#pass
	#pass

func _on_btn_delete_pressed() -> void:
	if building_node:
		var is_found:bool = false
		#var players = GameNetwork.players
		print("peer id:", multiplayer.get_unique_id())
		var peer_id = multiplayer.get_unique_id()
		if peer_id <= 0:
			return
		Global.notify_message("Current Team ID" + str(GameNetwork.player_info["team_id"]))
		Global.notify_message("Select Building Team ID" + str(building_node.team_id))
		if building_node.team_id == GameNetwork.player_info["team_id"]:
			is_found = true
		else:
			Global.notify_message("Wrong Team Building")
			#pass
		if is_found:
			print("Delete building unit.")
			
			building_node.has_method("request_delete")
			building_node.request_delete()
			building_node=null
			clear_building_info()
	pass

func clear_building_info()->void:
	label.text = "None"
	label_time.text = "0"
	label_team_id.text = "0"
	#pass
