extends "res://scenes/enemies/base/states/death.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MET_BABIES = preload("res://scenes/enemies/mets/met_mama/babies/met_baby.tscn")

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass
func _enter():
	var bullet_pos: Vector2 = $"../../met_baby_spawn1".global_position
	var bullet_pos2: Vector2 = $"../../met_baby_spawn2".global_position
	var bullet_pos3: Vector2 = $"../../met_baby_spawn3".global_position
	var baby1 = MET_BABIES.instance()
	var baby2 = MET_BABIES.instance()
	var baby3 = MET_BABIES.instance()
	baby1.direction = Vector2.ZERO
	owner.get_parent().call_deferred("add_child",baby1)
	baby1.set_deferred("global_position",owner.global_position)

	baby2 = MET_BABIES.instance()
	baby2.direction = Vector2.RIGHT
	owner.get_parent().call_deferred("add_child",baby2)
	baby2.set_deferred("global_position",owner.global_position)

	baby3 = MET_BABIES.instance()
	baby3.direction = Vector2.LEFT
	owner.get_parent().call_deferred("add_child",baby3)
	baby3.set_deferred("global_position",owner.global_position)
	._enter()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
