tool
extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(float) var time_to_drop:float = 1
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$StandOnTimer.wait_time = time_to_drop

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func open():
	$MainCollision.disabled = true

func close():
	$MainCollision.disabled = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_animation_finished(anim_name):
	if anim_name == "Open":
		$AnimationPlayer.play("Close",-1,1.5)


func _on_player_entered(body):
	if body is Player:
		$landing.play()
		$StandOnTimer.start()

func _on_player_exited(body):
	if body is Player:
		$StandOnTimer.stop()

func _on_timer_threshold_reached():
	$passing.play()
	$AnimationPlayer.play("Open",-1,1.5)
