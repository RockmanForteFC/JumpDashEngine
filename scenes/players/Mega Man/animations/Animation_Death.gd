extends Node2D

var explosion_speed = 65

func _ready():
	$DeathSound.play()
	$Timer.start()

func _process(delta):
	$Up.position.y -= explosion_speed * delta 
	
	$UpRight.position.y -= (explosion_speed - 20) * delta 
	$UpRight.position.x += (explosion_speed -20) * delta
	
	$Right.position.x += explosion_speed * delta
	
	$RightDown.position.x += (explosion_speed - 20) * delta
	$RightDown.position.y += (explosion_speed - 20) * delta
	
	$Down.position.y += explosion_speed * delta
	
	$DownLeft.position.y += (explosion_speed - 20) * delta
	$DownLeft.position.x -= (explosion_speed - 20) * delta
	
	$Left.position.x -= explosion_speed * delta
	
	$LeftUp.position.x -= (explosion_speed - 20) * delta
	$LeftUp.position.y -= (explosion_speed - 20) * delta

func _on_Timer_timeout():
	queue_free()
