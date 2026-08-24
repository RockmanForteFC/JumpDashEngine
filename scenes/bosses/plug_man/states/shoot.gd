extends "res://scenes/bosses/plug_man/states/common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var shoot_delay = $"../../TimerShootDelay"
onready var _animations_special: AnimationPlayer = $"../../AnimationPlayer"
var is_ready_to_shoot = false
var did_shoot = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	shoot_delay.connect("timeout", self, "_on_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _enter():
	shoot_delay.start()
	_animations_special.play("Shoot")
	is_ready_to_shoot = true

func _update(delta):
	if not did_shoot and is_ready_to_shoot:
		if owner.is_on_floor():
			did_shoot = true
			shoot()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_timeout():
	did_shoot = false
	is_ready_to_shoot = false
	emit_signal("finished", "idle")
