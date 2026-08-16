tool
extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(String, "UP","DOWN") var direction = "UP" setget play_animation
export(bool) var is_vertical:bool = false setget set_collision
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play(direction)
	if is_vertical:
		$Area2D/vertical.disabled = false
		$Area2D/horizontal.disabled = true 
	else:
		$Area2D/vertical.disabled = true
		$Area2D/horizontal.disabled = false 

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func play_animation(value):
	direction = value 
	$AnimatedSprite.play(value)

func set_collision(value):
	is_vertical = value 
	if value:
		$Area2D/vertical.disabled = false
		$Area2D/horizontal.disabled = true 
	else:
		$Area2D/vertical.disabled = true
		$Area2D/horizontal.disabled = false 

	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Area2D_body_entered(body):
	if body is Player:
		if direction == "UP" and !body.is_upside_down:
			body.set_reverse_gravity(true) 
			$AudioStreamPlayer.play()
		elif direction == "DOWN" and body.is_upside_down:
			body.set_reverse_gravity(false)
			$AudioStreamPlayer.play()
