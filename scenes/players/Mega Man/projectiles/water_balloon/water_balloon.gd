extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVE_SPEED = 230
const INITIAL_UPWARD_TRAJECTORY = -20
const MAX_FALL_SPEED = 700
const SPEED_INCREASE = 2.5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var is_reflected:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite.play("Shoot")
	if not $PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	$Audio/Shoot.play()
	velocity = Vector2(MOVE_SPEED * direction.x, INITIAL_UPWARD_TRAJECTORY)

func _process(delta):
	if !is_reflected:
		velocity.y = clamp(velocity.y + SPEED_INCREASE, -MAX_FALL_SPEED,MAX_FALL_SPEED)
		move_and_slide(velocity,Vector2.UP)
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			set_process(false)
			$Sprite.play("Pop")
			yield($Sprite,"animation_finished")
			queue_free()
	else:
		velocity = direction * (MOVE_SPEED)
		move_and_slide(velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/Shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Shoot, "finished")
	.queue_free()

func reflect() -> void:
	is_reflected = true
	_free_groups()
	$Audio/Reflect.play()
	direction = Vector2(-direction.x, -1)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
	$CollisionShape2D.set_deferred("disabled", true)
	
func _free_groups():
	if is_in_group("WaterBalloonP1"):
		remove_from_group("WaterBalloonP1")
	elif is_in_group("WaterBalloonP1"):
		remove_from_group("WaterBalloonP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
