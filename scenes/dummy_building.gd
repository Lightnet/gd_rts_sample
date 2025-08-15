extends StaticBody3D

var building_unit:BuildingUnit

func _ready() -> void:
	building_unit = BuildingUnit.new()
	building_unit.name = "DummyBuilding"
	pass
	
func _process(delta: float) -> void:
	pass

func get_building_name()->String:
	return building_unit.name
