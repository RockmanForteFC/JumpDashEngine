extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_timer_running : bool = false
var platform_died : bool 
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

func _process(delta):
	if has_node("Raycasts") :
		for node in $Raycasts.get_children():
			if node.is_colliding() and not is_timer_running :
				$Raycasts.queue_free()
				$Platform.hide()
				$Disappear.show()
				$AnimationPlayer.play("Disappear")
				set_process(false)
				break
		if not is_timer_running :
			$Timer1.start()
			is_timer_running = true
			$Raycasts.queue_free()
			set_process(false)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Disappear":
		.queue_free()

func _on_Timer1_timeout():
	$Platform.playing = false
	$Timer2.start()

func _on_Timer2_timeout():
	$Platform.hide()
	$Disappear.show()
	$AnimationPlayer.play("Disappear")

func _on_PreciseVisibilityNotifier2D_camera_exited():
	.queue_free()
