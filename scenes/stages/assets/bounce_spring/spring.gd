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
export(String,"plantman","brass") var type:String = "brass"

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("Idle_" + type)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Area2D_body_entered(body):
	if body is Player:
		$AudioStreamPlayer.play()
		body.on_spring_bounce()
		$AnimatedSprite.play("Bounce_" + type)
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.play("Idle_" + type)
