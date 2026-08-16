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
var velocity:Vector2 = Vector2.ZERO
var is_reflecting:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	$AnimationPlayer.play("pillarh")
	if direction == Vector2.LEFT:
		scale.x *= -1
		
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()
	
func reflect() -> void:
	is_reflecting = true
	_free_groups()
	$Audio/Deflect.play()
	velocity = Vector2(-velocity.x, -1)
	$Sprite.flip_h = !$Sprite.flip_h
	set_collision_mask_bit(Bitmask.stage,false)
	set_collision_mask_bit(Bitmask.spike,false)
	set_collision_mask_bit(Bitmask.enemy,false)
	set_collision_mask_bit(Bitmask.top_solid_land_gimick,false)
	set_collision_layer_bit(Bitmask.projectile,false)
	$CollisionShape2D.set_deferred("disabled",true)
	queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("FlameBlastP1"):
		remove_from_group("FlameBlastP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("pillarh"):
		queue_free()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
