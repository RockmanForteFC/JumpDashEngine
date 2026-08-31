extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const NAPALM_SPEED = 55
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity = Vector2.ZERO
var is_reflecting = false
var did_bounce:bool = false
var did_explode:bool = false
var can_explode:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	velocity.y = 70
	$Timer.connect("timeout",self,"can_bounce")
	$Die.start()
	$Audio/Shot.play()
	if direction.x < 0:
		$AnimatedSprite.flip_h = true
	can_explode = true
	velocity = direction.normalized() * NAPALM_SPEED
	velocity.y = -70

func _physics_process(delta):
	if !is_reflecting:
		 velocity.y = clamp(velocity.y + Physics.GRAVITY,-Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)

	move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		velocity.y = -100
		$Timer.start()
	if is_on_wall():
		velocity.x *= -1
	if is_on_ceiling():
		velocity.y = 0
	if did_hit_enemy:
		explode()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()

func can_bounce():
	did_bounce = false

func _free_groups():
	if is_in_group("NapalmBombP1"):
		remove_from_group("NapalmBombP1")

func reflect()-> void:
	_free_groups()
	$Audio/Deflect.play()
	$Timer.stop()
	$Die.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	consumed = true
	is_reflecting = true
	velocity = Vector2(-direction.x , -1) * (NAPALM_SPEED * 4)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)

func explode():
	if !did_explode:
		did_hit_enemy = true
		did_explode = true
		_free_groups()
		set_collision_mask_bit(Bitmask.stage, false)
		set_physics_process(false)
		is_piercing = true
		breaks_on_enemy = false
		$AnimationPlayer.play("collision_change")
		$Audio/Explosion.play()
		$explosion.play("Explosion")
		$explosion.show()
		$AnimatedSprite.hide()
		yield($explosion,"animation_finished")
		$CollisionShape2D.set_deferred("disabled",true)
		yield($Audio/Explosion,"finished")
		queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()


func _on_Die_timeout():
	explode()
