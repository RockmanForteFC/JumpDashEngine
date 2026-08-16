extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MAX_SPEED = 350
const SPEED_INCREASE = 5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_reflecting = false
export (Vector2) var speed = Vector2(65, 0)
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Audio/Shot.play()
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	velocity = direction.normalized() * speed

func _physics_process(delta):
	if !is_reflecting:
		 velocity.y = clamp(velocity.y - SPEED_INCREASE, -MAX_SPEED, MAX_SPEED)
		 
	move_and_slide(velocity, Vector2.UP)
	
	if did_hit_enemy:
		queue_free()
	
	
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	set_physics_process(false)
	#adding the animation stuff in the queue free so you see the animation when you swap weapons.
	$AnimatedSprite.hide()
	$AirCloud/Sprite.flip_h = $AnimatedSprite.flip_h
	#make the animation play at 2x speed.
	$AirCloud/AnimationPlayer.play("AirSmoke", -1, 2.0)
	$CollisionShape2D.set_deferred("disabled", true)
	velocity.y = 0
	speed.x = 0
	consumed = true
	if $Audio/Shot.playing:
		yield($Audio/Shot, "finished")
	yield($AirCloud/AnimationPlayer,"animation_finished")
	.queue_free()

func _free_groups():
	if is_in_group("AirShooterP1"):
		remove_from_group("AirShooterP1")
		
func reflect()-> void:
	$Audio/Deflect.play()
	queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
