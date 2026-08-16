extends "common.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var _timer_shoot_delay: Timer = $"../../TimerShootDelay"

#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready() -> void:
	_timer_shoot_delay.connect("timeout", self, "_on_timeout")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter():
	#only shoot if wave man is on the floor
	if owner.is_on_floor():
		animated_sprite.play("Shoot")
		_timer_shoot_delay.start()
	else:
		emit_signal("finished", "idle")


#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_timeout():
	shoot()
	emit_signal("finished","idle")
