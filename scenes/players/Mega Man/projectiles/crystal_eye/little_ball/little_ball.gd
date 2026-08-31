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
var velocity = Vector2(196, 196)
var bounce_factor = 1

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	$Timer.start()
func _physics_process(delta):
	var collision = move_and_collide((velocity * direction.normalized()) * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity *= bounce_factor
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()

func explode():
	set_physics_process(false)
	$AnimatedSprite.visible = false
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_mask_bit(Bitmask.stage, false)
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.visible = true
	$Explosion.play("explode")
	yield($Explosion,"animation_finished")
	queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("CrystalEyeP1"):
		remove_from_group("CrystalEyeP1")

func reflect() -> void:
	_free_groups()
	$deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_mask_bit(Bitmask.stage, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Timer_timeout():
	explode()


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
