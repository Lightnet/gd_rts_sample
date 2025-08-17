extends Resource
class_name UnitData

@export var name:String
@export var health:float = 100
@export var health_max:float = 100

# base on peer id
# 0 = neutral ?
# 1 = server host
# 2 = enmey ?
@export var team_id:int = 0

# base on peer id
# -1 = enemy or free to all.
# 0 = neutral
# 1 = server peer id
@export var ally_id:int = -1
