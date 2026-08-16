extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const GYRO_ATTACK_SPEED:float = 192.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity
var is_reflecting:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	$Audio/Gyro.play()
	set_process(false)
func _physics_process(delta):
	move_and_slide((direction.normalized() * GYRO_ATTACK_SPEED), Vector2.UP)
	if not is_reflecting:
		if Physics.is_action_pressed("action_up_p1"):
			direction = Vector2.UP
			set_process(true)
		elif Physics.is_action_pressed("action_down_p1"):
			direction = Vector2.DOWN
			set_process(true)
func _process(delta):
	set_physics_process(false)
	move_and_slide((direction.normalized() * GYRO_ATTACK_SPEED), Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func reflect() -> void:
	_free_groups()
	set_physics_process(false)
	set_process(true)
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)

func queue_free() -> void:
	$Audio/Gyro.stop()
	_free_groups()
	consumed = true
	if $Audio/Gyro.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Gyro, "finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("GyroAttackP1"):
		remove_from_group("GyroAttackP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
