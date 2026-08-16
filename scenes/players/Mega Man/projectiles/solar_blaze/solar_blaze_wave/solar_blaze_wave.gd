extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SOLAR_WAVE_SPEED:float = 224.0
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
	$AnimatedSprite.play("wave")
	if direction == Vector2.LEFT:
		$AnimatedSprite.flip_h = true
func _physics_process(delta):
	move_and_slide((direction.normalized() * SOLAR_WAVE_SPEED), Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("SolarBlazeP1"):
		remove_from_group("SolarBlazeP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
