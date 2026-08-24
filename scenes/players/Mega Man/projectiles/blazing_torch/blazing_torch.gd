extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const fireball = preload("res://scenes/players/Mega Man/projectiles/blazing_torch/fireball.tscn")

const MOVE_SPEED = 450
const INITIAL_UPWARD_TRAJECTORY = -20
const MAX_FALL_SPEED = 700
const SPEED_INCREASE = 2.5
#-------------------------------------------------
#      Signals
#-------------------------------$"."------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var is_reflected:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	var f = fireball.instance()
	get_parent().call_deferred("add_child", f)
	f.set_deferred("global_position", Vector2(global_position.x + (direction.x * 5),global_position.y -10))
	f.set_deferred("flip_h", true if direction == Vector2.LEFT else false)
	if not $PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	set_physics_process(false)
	$Audio/Shoot.play()



func _physics_process(delta):
	if !is_reflected:
		move_and_slide(velocity,Vector2.UP)
	else:
		velocity = direction * (MOVE_SPEED*2)
		move_and_slide(velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func start():
	if direction == Vector2.LEFT:
		scale.x *= -1
	direction.y = 1
	set_physics_process(false)
	$AnimationPlayer.play("Ball")
	$Tween.interpolate_property(self, "position", position, Vector2(position.x + (direction.x * 18), position.y-60) ,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	$AnimationPlayer.play("BallExplode", -1, 3.0)
	velocity = direction * MOVE_SPEED


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
	$CollisionShape2D2.set_deferred("disabled", true)

func _free_groups():
	if is_in_group("BlazingTorchP1"):
		remove_from_group("BlazingTorchP1")
	elif is_in_group("BlazingTorchP1"):
		remove_from_group("BlazingTorchP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "BallExplode":
		set_physics_process(true)
