extends Area2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var player: Player
var is_shot_ready := true

onready var _timer: Timer = $"../Timer"
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_TriggerArea_body_entered(body):
	if body is Player:
		player = body as Player
		if is_shot_ready:
			is_shot_ready = false
			_timer.call_deferred("emit_signal", "timeout")
			_timer.start()    # Reset timer


func _on_TriggerArea_body_exited(body):
	if body is Player:
		player = null
