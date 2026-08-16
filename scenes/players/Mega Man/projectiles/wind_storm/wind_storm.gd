extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const WIND_SPEED = 150
const FRAME_PHYSICS_CHANGE:int = 10
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_reflecting = false
var frame_count:int = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	velocity.y = 45
	$Timer.start()
	$Audio/Shot.play()
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	velocity = direction.normalized() * WIND_SPEED
	velocity.y = -30

func _physics_process(delta):
	if !is_reflecting:
		#This gives the first 10 frames more vertical distance before the gravity pulls it to the ground.
		if frame_count <= FRAME_PHYSICS_CHANGE:
			velocity.y = clamp(velocity.y + Physics.GRAVITY_WATER,-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
		else:
			velocity.y = clamp(velocity.y + Physics.GRAVITY,-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
		frame_count += 1
	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = 0
	if is_on_wall():
		velocity.x *= -1
	if is_on_ceiling():
		velocity.y = 0
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shot, "finished")
	.queue_free()

func _free_groups():
	if is_in_group("WindStormP1"):
		remove_from_group("WindStormP1")
		
func reflect()-> void:
	$CollisionShape2D.set_deferred("disabled", true)
	_free_groups()
	$Audio/Deflect.play()
	$Timer.stop()
	consumed = true
	is_reflecting = true
	velocity = Vector2(-direction.x, -1) * (WIND_SPEED * 2)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_Timer_timeout():
	queue_free()
