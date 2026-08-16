extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const YAMATO_SPEAR_SPEED = 200
const TRAJECTORY_SPEED = 10
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var trajectory:Vector2=Vector2.DOWN
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	velocity=Vector2(direction.x*YAMATO_SPEAR_SPEED,trajectory.y*TRAJECTORY_SPEED)
	$yamatoshot.play()
	if direction.x < 0:
		$Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	move_and_slide(velocity, Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $yamatoshot.playing:
		yield($yamatoshot, "finished")
	.queue_free()
	
func reflect() -> void:
	_free_groups()
	$yamatoreflect.play()
	velocity = Vector2(-velocity.x, -1*YAMATO_SPEAR_SPEED)
	$Sprite.flip_h = !$Sprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("YamatoSpearP1"):
		remove_from_group("YamatoSpearP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
