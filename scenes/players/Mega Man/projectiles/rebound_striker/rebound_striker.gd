extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MAX_BOUNCES:int = 5
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var move_speed:float = 224.0
var bounces:int = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("first_two_bounces")

func _physics_process(delta):
	move_and_slide((direction.normalized() * move_speed), Vector2.UP)
	if bounces == 0:
		if is_on_wall():
			direction.y = Vector2.UP.y
			_bounce_on_wall()
	elif is_on_wall():
		_bounce_on_wall()
	if is_on_ceiling() or is_on_floor():
		_bounce_on_ceiling_floor()
	if bounces == 2:
		third_bounce_blink()
	if bounces == 3:
		fourth_bounce_flash()
	if bounces == MAX_BOUNCES:
		explode()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _bounce_on_wall():
	direction.x *= -1
	$Bounce.play()
	bounces += 1
	damage += 1

func _bounce_on_ceiling_floor():
	direction.y *= -1
	$Bounce.play()
	bounces += 1
	damage += 1

func third_bounce_blink():
	$AnimatedSprite.play("third_bounce")

func fourth_bounce_flash():
	$AnimatedSprite.play("fourth_fifth_bounce")

func explode():
	$AnimatedSprite.hide()
	move_speed = 0.0
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2.visible = true
	$AnimatedSprite2.play("default")
	yield($AnimatedSprite2, "animation_finished")
	queue_free()


func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()

func reflect() -> void:
	if bounces == 0:
		direction.y = Vector2.UP.y
		_bounce_on_wall()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("ReboundStrikerP1"):
		remove_from_group("ReboundStrikerP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
