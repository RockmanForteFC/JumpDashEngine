extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const ARROW_SPEED:float = 208.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_on_wall:bool = false
var stopping_point = null
var is_reflecting:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	set_physics_process(false)
	$Node2D/AnimationPlayer.play("shoot")
	$Shoot.play()
	$Startup.start()
	if direction.x < 0:
		$Node2D/Sprite.flip_h = true
		$RayCast2D.cast_to.x = -12

func _physics_process(delta):
	if is_reflecting:
		var movement = Vector2(-direction.x, sign(scale.y) * Vector2.UP.y)
		global_position +=  ((movement * ARROW_SPEED) * delta)
	else:
		global_position.x = global_position.x + ((direction.x * ARROW_SPEED) * delta)
		if stopping_point != null:
			global_position.x = stopping_point.x  - (8* direction.x)
			set_physics_process(false)
			attach()
	#backup incase it goes offscreen forever
	if global_position.distance_to(PlayerValues.player.global_position) > 256:
		queue_free()

func _process(delta):
	if $RayCast2D.is_colliding():
		show()
		stopping_point = $RayCast2D.get_collision_point()
		set_process(false)


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func attach():
	set_physics_process(false)
	$Node2D/AnimationPlayer.play("attach")
	set_collision_mask_bit(Bitmask.enemy, false)
	$disappear.start()
	$flash_timer.start()

func reflect() -> void:
	$Node2D/KinematicBody2D/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D2.set_deferred("disabled",true)
	is_reflecting = true
	$Deflect.play()
	$Node2D/Sprite.flip_h = !$Node2D/Sprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
	set_collision_mask_bit(Bitmask.stage, false)
	$RayCast2D.enabled = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Startup_timeout():
	set_physics_process(true)

func _on_disappear_timeout():
	$Node2D/AnimationPlayer.stop()
	show()
	$explode.play()
	$AnimatedSprite.play("explode")
	$Node2D/Sprite.hide()
	$Node2D/KinematicBody2D/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D2.set_deferred("disabled",true)
	yield($AnimatedSprite,"animation_finished")
	queue_free()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_flash_timer_timeout():
	$Node2D/AnimationPlayer.play("flash")
