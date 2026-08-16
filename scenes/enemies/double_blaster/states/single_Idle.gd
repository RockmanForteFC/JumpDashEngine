extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TRIGGER_DISTANCE:float = 98.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../IdleShootTimer".connect("timeout", self, "prepare_action")

func _enter():
	owner.is_direction_locked = false
	get_parent().state = "idle"
	$"../../AnimatedSprite".play("Idle")
	$"../../IdleShootTimer".start()

func _update(delta):
	._update(delta)
	owner.check_turn_around()

func _exit():
	$"../../IdleShootTimer".stop()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func prepare_action():
	emit_signal("finished","shoot")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
