extends PanelContainer

@onready var label: Label = $VBoxContainer/HBoxContainer/Label2

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	pass
	
func set_building_info(building_unit:BuildingUnit):
	label.text = building_unit.name
	pass
