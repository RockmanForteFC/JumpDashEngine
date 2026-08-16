extends CanvasLayer

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal tick_health
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var has_had_cold_water_first_tick:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("Fade_in")
	if Config.show_filters:
		$Tween.interpolate_property($ColorRect,"modulate",Color(1,1,1,0), Color(1,1,1,1), 1.3,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.interpolate_property($AnimatedSprite,"modulate",Color(1,1,1,0),Color(1,1,1,1),1.3,Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	if !has_had_cold_water_first_tick:
		$Timer.wait_time = 1
		has_had_cold_water_first_tick = true
		$Timer.start()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free():
	$AnimatedSprite.play("Fade_out")
	$Tween.stop_all()
	$Timer.stop()
	var t = get_tree().create_tween()
	t.tween_property($ColorRect,"modulate",Color(1,1,1,0),0.3)
	yield(t,"finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Timer_timeout():
	$Timer.wait_time = 0.4
	emit_signal("tick_health")
	$Timer.start()
