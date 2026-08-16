extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal block_despawn
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if !$PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	$AnimationPlayer.play("spawn")
	set_physics_process(false)

func _physics_process(delta):
	velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	move_and_slide(velocity,Vector2.UP)
	if did_hit_enemy:
		_break()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _break():
	set_physics_process(false)
	$Sprite.hide()
	$Particles2D.emitting = true
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("default")
	$Audio/Break.play()
	yield($AnimatedSprite,"animation_finished")
	queue_free()
	
func queue_free() -> void:
	emit_signal("block_despawn")
	_free_groups()
	consumed = true
	if $Audio/Break.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/Break, "finished")
	.queue_free()
	
func reflect() -> void:
	_break()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("BlockDropperPieceP1"):
		remove_from_group("BlockDropperPieceP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("spawn"):
		set_physics_process(true)
