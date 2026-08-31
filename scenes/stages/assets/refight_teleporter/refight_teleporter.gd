extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal teleporter_touched
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_active:bool = true
var did_TP:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if is_active:
		$AnimatedSprite.play("ON")
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
	else:
		$AnimatedSprite.play("OFF")
		$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _physics_process(delta):
	if is_active and !did_TP:
		for body in $Area2D.get_overlapping_bodies():
			if body is LadderController and PlayerValues.player.is_ready_to_teleport():
				did_TP = true
				$AnimationPlayer.play("tp")
				PlayerValues.player.touched_tp = true
				yield(get_tree().create_timer(0.1),"timeout")
				PlayerValues.player.dont_accept_inputs()
				yield(get_tree().create_timer(0.1),"timeout")
				#PlayerValues.player._stop_moving()
				var tween = get_tree().create_tween()
				tween.tween_property(PlayerValues.player, "global_position:x", global_position.x, 0.1)
				yield(tween,"finished")
				PlayerValues.is_teleporting = true
				emit_signal("teleporter_touched")
				PlayerValues.player.state_machine_lockdown = false
				$Timer.start()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func activate():
	is_active = true
	$AnimatedSprite.play("ON")
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$Sprite.frame = 0

func deactivate():
	is_active = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.play("OFF")
	$Sprite.frame = 1
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Area2D_body_entered(body):
	pass
#	if is_active:
#		if body is Player and !body.is_dead and !body.touched_tp:
#			$AnimationPlayer.play("tp")
#			PlayerValues.player.touched_tp = true
#			yield(get_tree().create_timer(0.1),"timeout")
#			PlayerValues.player.dont_accept_inputs()
#			yield(get_tree().create_timer(0.1),"timeout")
#			#PlayerValues.player._stop_moving()
#			var tween = get_tree().create_tween()
#			tween.tween_property(PlayerValues.player, "global_position:x", global_position.x, 0.1)
#			yield(tween,"finished")
#			PlayerValues.is_teleporting = true
#			emit_signal("teleporter_touched")
#			PlayerValues.player.state_machine_lockdown = false

func reset_animation_frame():
	$AnimatedSprite.frame = 0

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "tp":
		$wall_left.set_deferred("disabled",true)
		$wall_left2.set_deferred("disabled",true)
		$AnimatedSprite.play("ON")

func _on_Timer_timeout():
	did_TP = false
