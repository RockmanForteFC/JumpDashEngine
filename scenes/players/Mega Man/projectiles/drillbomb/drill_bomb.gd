extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const frame_limit = 5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var DRILLSPEED = 200
var did_explode:bool = false
var velocity:Vector2 = Vector2.ZERO
var is_reflecting:bool = false
var frames = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	set_physics_process(true)
	$Audio/drilling.play()
	if direction.x < 0:
		$AnimatedSprite.flip_h = true

func _physics_process(delta: float) -> void:
	frames += 1
	move_and_slide((direction.normalized() * DRILLSPEED), Vector2.UP)
	if not is_reflecting:
		if frames >= frame_limit:
			if Input.is_action_just_pressed("action_shoot_p1"):
				explode()
		if did_hit_enemy:
			if not did_explode:
				explode()
		if is_on_wall():
			if !did_explode:
				explode()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func explode():
	set_physics_process(false)
	if !did_explode:
		did_hit_enemy = true
		did_explode = true
		_free_groups()
		set_collision_mask_bit(Bitmask.stage, false)
		set_physics_process(false)
		is_piercing = true
		breaks_on_enemy = false
		$AnimationPlayer.play("collision_change")
		$Audio/explosion.play()
		$explosion.play("Explosion")
		$explosion.show()
		$AnimatedSprite.hide()
		yield($explosion, "animation_finished")
		$CollisionShape2D.set_deferred("disabled",true)
		yield($Audio/explosion,"finished")
		queue_free()
	
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/drilling.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/drilling, "finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func reflect() -> void:
	is_reflecting = true
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	$CollisionShape2D.set_deferred("disabled", true)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
	
func _free_groups():
	if is_in_group("DrillBombP1"):
		remove_from_group("DrillBombP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
