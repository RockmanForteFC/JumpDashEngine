extends StateMachine

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

signal player_shoot

#-------------------------------------------------
#      Properties
#-------------------------------------------------

var _auto_charge_enabled: bool

onready var inputs: InputHandler = get_node("../Inputs")

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	_set_auto_charge_enabled(Config.auto_charge_enabled)
	Config.connect("auto_charge_enabled", self, "_set_auto_charge_enabled")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func is_holding_shoot() -> bool:
	return !inputs.is_locked(false) and \
		inputs.is_action_pressed(InputHandler.Action.SHOOT) == (!_auto_charge_enabled)

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _set_auto_charge_enabled(enabled: bool) -> void:
	_auto_charge_enabled = enabled

#-------------------------------------------------
#      Connections
#-------------------------------------------------
