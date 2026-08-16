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
	var distance_from_player = Vector2(owner.global_position.x,0).distance_to(Vector2(PlayerValues.player.global_position.x,0))
	if distance_from_player < TRIGGER_DISTANCE:
		emit_signal("finished","bomb")
	else:
		emit_signal("finished","shoot")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
