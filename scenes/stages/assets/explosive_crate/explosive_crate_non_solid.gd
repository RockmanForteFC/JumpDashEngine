extends "res://scenes/stages/assets/explosive_crate/explosive_crate.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func activate(throwaway = null):
	health = 3
	$projectile_detector/CollisionShape2D.set_deferred("disabled",false)
	$explosion_detector/CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite.show()
	$AnimatedSprite.play("Idle")
	is_exploding = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
