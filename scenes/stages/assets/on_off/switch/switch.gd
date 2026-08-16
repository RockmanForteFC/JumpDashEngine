extends StaticBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal change_state(state)
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var current_state = Physics.lever_state
var was_t_pulsed:bool = false 

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if current_state == 0:
		$AnimatedSprite.play("switch_blue")
	else:
		$AnimatedSprite.play("switch_red")

func _physics_process(delta):
	if current_state != Physics.lever_state:
		current_state = Physics.lever_state
		if Physics.lever_state == 0:
			$AnimatedSprite.play("switch_change_blue")
			yield($AnimatedSprite,"animation_finished")
			$AnimatedSprite.play("switch_blue")
		elif Physics.lever_state == 1:
			$AnimatedSprite.play("switch_change_red")
			yield($AnimatedSprite,"animation_finished")
			$AnimatedSprite.play("switch_red")
			
	for body in $switch_collision.get_overlapping_bodies():
		if body.is_in_group("PlayerWeapons"):
			if body.key_name != "tremor_pulse":
				$AudioStreamPlayer.play()
				body.queue_free()
				if Physics.lever_state == 0:
					$AnimatedSprite.play("switch_change_red")
					Physics.lever_state = 1
					current_state = 1
					emit_signal("change_state")
					yield($AnimatedSprite,"animation_finished")
					$AnimatedSprite.play("switch_red")
				elif Physics.lever_state == 1:
					$AnimatedSprite.play("switch_change_blue")
					Physics.lever_state = 0
					current_state = 0
					emit_signal("change_state")
					yield($AnimatedSprite,"animation_finished")
					$AnimatedSprite.play("switch_blue")
			else:
				if !was_t_pulsed:
					$AudioStreamPlayer.play()
					was_t_pulsed = true
					$Timer.start()
					if Physics.lever_state == 0:
						$AnimatedSprite.play("switch_change_red")
						Physics.lever_state = 1
						current_state = 1
						emit_signal("change_state")
						yield($AnimatedSprite,"animation_finished")
						$AnimatedSprite.play("switch_red")
					elif Physics.lever_state == 1:
						$AnimatedSprite.play("switch_change_blue")
						Physics.lever_state = 0
						current_state = 0
						emit_signal("change_state")
						yield($AnimatedSprite,"animation_finished")
						$AnimatedSprite.play("switch_blue")
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
	if anim_name == "goto_state_1" or anim_name == "goto_state_0":
		$AnimationPlayer.play("state_" + str(current_state))


func _on_reflect_shot_area_body_entered(body):
	if body.is_in_group("PlayerWeapons"):
		if !body.is_piercing:
			body.reflect()


func _on_Timer_timeout():
	was_t_pulsed = false
