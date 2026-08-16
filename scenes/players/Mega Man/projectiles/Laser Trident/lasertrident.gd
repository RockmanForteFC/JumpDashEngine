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
var LASER_TRIDENT_SPEED = 300

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	$tridentshot.play()
	
	$Sprite/AnimationPlayer.play("flash")
	if direction.x < 0:
		$Sprite.flip_h = true
	
		
func _physics_process(delta: float) -> void:
	move_and_slide((direction.normalized() * LASER_TRIDENT_SPEED), Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func get_normal_speed():
	return Physics.LASER_TRIDENT_SPEED
	
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $tridentshot.playing:
		yield($tridentshot, "finished")
	.queue_free()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("LaserTridentP1"):
		remove_from_group("LaserTridentP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_screen_exited():
	.queue_free()
