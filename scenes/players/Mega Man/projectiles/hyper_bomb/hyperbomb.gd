extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BOOM = preload ("res://scenes/players/Mega Man/projectiles/hyper_bomb/hyper_bomb_explosion.tscn")
const BOUNCE_LIMIT = 2

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2 = Vector2.ZERO
var curveSpeed:float = 0.0
var SPEED:float = 175.0
var did_explode:bool = false
var bounces = 0
var did_bounce:bool = false
var upward_momentum = -20
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if direction.x < 0:
		$Sprite.flip_h = true
	velocity = Vector2(SPEED * direction.x, 0)
	$Timer.start()

func _physics_process(delta):
	curveSpeed = clamp(curveSpeed + 1,-2,10)
	velocity.y = clamp(velocity.y + curveSpeed, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	var _move = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		if bounces != BOUNCE_LIMIT:
			bounces += 1
			if bounces == 1:
				velocity.y = -120
				velocity.x = 80 * direction.x
			if bounces == 2:
				velocity.y = -60
				velocity.x = 40 * direction.x
		elif bounces >= BOUNCE_LIMIT:
			velocity = Vector2.ZERO
	if is_on_wall():
		bounces = BOUNCE_LIMIT
		velocity = Vector2.ZERO
	if did_hit_enemy:
		if !did_explode:
			explode()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func explode():
	if !did_explode:
		did_explode = true
		_free_groups()
	var explode = BOOM.instance()
	get_parent().call_deferred("add_child", explode)
	explode.set_deferred("global_position",global_position)
	queue_free()

func queue_free() -> void:
	_free_groups()
	consumed = true
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("HyperBombP1"):
		remove_from_group("HyperBombP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_Timer_timeout():
	if not did_explode:
		explode()

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
