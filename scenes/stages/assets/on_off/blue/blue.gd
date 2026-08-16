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
var current_state = Physics.lever_state
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if current_state == 0:
		$AnimatedSprite.play("blue")
	else:
		$AnimatedSprite.play("off")

func _physics_process(delta):
	if current_state != Physics.lever_state:
		current_state = Physics.lever_state
		if Physics.lever_state == 1:
			$AnimatedSprite.play("blue_off")
			$top.set_deferred("disabled",true)
			$bottom.set_deferred("disabled",true)
			$right.set_deferred("disabled",true)
			$left.set_deferred("disabled",true)
			yield($AnimatedSprite,"animation_finished")
			$AnimatedSprite.play("off")
		elif Physics.lever_state == 0:
			$AnimatedSprite.play("blue_on")
			$top.set_deferred("disabled",false)
			$bottom.set_deferred("disabled",false)
			$right.set_deferred("disabled",false)
			$left.set_deferred("disabled",false)
			yield($AnimatedSprite,"animation_finished")
			$AnimatedSprite.play("blue")
