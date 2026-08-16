tool
extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export(bool) var is_upside_down: bool setget _set_is_upside_down

var gravity_direction: Vector2 = Vector2.DOWN

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	set_process(!Engine.editor_hint)
	set_physics_process(!Engine.editor_hint)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _set_is_upside_down(val: bool) -> void:
	is_upside_down = val
	gravity_direction = (2.0 * float(!is_upside_down) - 1.0) * Vector2.DOWN
	scale.y = abs(scale.y) * gravity_direction.y

#-------------------------------------------------
#      Connections
#-------------------------------------------------
