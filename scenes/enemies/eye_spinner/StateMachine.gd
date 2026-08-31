extends "res://scenes/enemies/base/scripts/state_machine.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

const TURN_FRAME_DELAY:int = 5

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var frame:int = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	states_map["wall-down-moving-right"] = $WallDownMovingRight
	states_map["wall-down-moving-left"] = $WallDownMovingLeft

	states_map["wall-left-moving-up"] = $WallLeftMovingUp
	states_map["wall-left-moving-down"] = $WallLeftMovingDown

	states_map["wall-right-moving-up"] = $WallRightMovingUp
	states_map["wall-right-moving-down"] = $WallRightMovingDown

	states_map["wall-up-moving-right"] = $WallUpMovingRight
	states_map["wall-up-moving-left"] = $WallUpMovingLeft


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
