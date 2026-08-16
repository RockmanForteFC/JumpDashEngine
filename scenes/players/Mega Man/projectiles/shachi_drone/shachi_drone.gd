extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const DOLPHIN_SPEED:float = 24.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var low_position:Vector2
var high_position:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	set_physics_process(false)
	$startup.start()
	$Timer.start()
	
	if direction.x < 0:
		$AnimatedSprite.flip_h = true

func _physics_process(delta: float) -> void:
	global_position += direction * DOLPHIN_SPEED * delta

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Timer_timeout():
	$AnimationPlayer.play("flash")
	$Timer2.start()


func _on_Timer2_timeout():
	queue_free()


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_startup_timeout():
	set_physics_process(true)
