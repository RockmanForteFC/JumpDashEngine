extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const EXPLOSION = preload("res://scenes/enemies/common/damaging_explosion/explosion.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity: Vector2 = Vector2.ZERO
var direction = 1
var element:int
var damage:int = 4
var did_explode:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	velocity.y = clamp(velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
	move_and_slide(velocity,Vector2.UP)
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		explode()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func explode():
	if !did_explode:
		did_explode = true
		velocity = Vector2.ZERO
		$AnimatedSprite.play("Flash")
		var e = EXPLOSION.instance()
		e.damage = damage
		get_parent().call_deferred("add_child",e)
		e.set_deferred("global_position", global_position)
		queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if body is Player and not body.is_dead:
		velocity.x = 0
		body.on_hit(damage, Physics.Damage.projectile,element)
		explode()
		
