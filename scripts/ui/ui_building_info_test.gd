extends PanelContainer

@onready var label: Label = $VBoxContainer/HBoxContainer/Label2
@onready var label_time: Label = $VBoxContainer/HBoxContainer2/Label2
var building_unit:BuildingUnit
var building_node:Node3D

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	if building_node:
		label_time.text = "%.2f" % building_node.time
	#pass

func set_building_node(_node:Node3D):
	building_node = _node
	set_building_info(_node.building_unit)
	#pass

func set_building_info(_building_unit:BuildingUnit):
	building_unit = _building_unit
	label.text = _building_unit.name
	#pass

func _on_btn_build_pressed() -> void:
	if building_node:
		if building_node.has_method("request_build"):
			print("build unit")
			building_node.request_build()
			#pass
	#pass

func _on_btn_stop_pressed() -> void:
	if building_node:
		if building_node.has_method("request_stop_build"):
			building_node.request_stop_build()
			#pass
	#pass


func _on_btn_delete_pressed() -> void:
	if building_node:
		building_node.has_method("request_delete")
		building_node.request_delete()
		building_node=null
	pass
