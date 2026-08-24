extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVE_SPEED = 176.0
const BOUNCE_LIMIT = 10
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal segment_despawn
#-------------------------------------------------
#      Properties
#-------------------------------------------------

var velocity:Vector2
var is_reflected:bool = false
var laser_direction = "straight"
var bounces:int = 0
onready var anim = $AnimatedSprite
var current_frame = 0
var check_frame = 3
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	anim.play("straight")
	laser_direction = "straight"
	velocity = Vector2( MOVE_SPEED * direction.x, 0)

func _physics_process(delta):
	current_frame +=1
	if check_frame == current_frame:
		if !$PreciseVisibilityNotifier2D.is_on_screen():
			queue_free()
		set_physics_process(false)

func _process(delta):
	if !is_reflected:
		move_and_slide(velocity.normalized() * MOVE_SPEED ,Vector2.UP)
		if is_on_wall():
			if laser_direction == "straight":
				laser_direction = "up"
				anim.play("up_left_down_right") if direction == Vector2.RIGHT else anim.play("up_right_down_left")
				velocity.y = Vector2.UP.y
			elif laser_direction == "up":
				anim.play("up_left_down_right") if direction == Vector2.RIGHT else anim.play("up_right_down_left")
			elif laser_direction == "down":
				anim.play("up_left_down_right") if direction == Vector2.LEFT else anim.play("up_right_down_left")
			direction.x *= -1
			bounces += 1
			velocity.x =  direction.x
		elif is_on_floor():
			laser_direction = "up"
			bounces += 1
			velocity.y = Vector2.UP.y
			anim.play("up_left_down_right") if direction == Vector2.LEFT else anim.play("up_right_down_left")
		elif is_on_ceiling():
			laser_direction = "down"
			bounces += 1
			velocity.y = Vector2.DOWN.y
			anim.play("up_left_down_right") if direction == Vector2.RIGHT else anim.play("up_right_down_left")
		if bounces == BOUNCE_LIMIT:
			set_collision_mask_bit(Bitmask.stage, false)

	else:
		velocity = direction * (MOVE_SPEED)
		anim.play("up_left_down_right") if direction == Vector2.LEFT else anim.play("up_right_down_left")
		move_and_slide(velocity,Vector2.UP)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func queue_free() -> void:
	emit_signal("segment_despawn")
	_free_groups()
	consumed = true
	.queue_free()

func reflect() -> void:
	is_reflected = true
	_free_groups()
	$Audio/Reflect.play()
	direction = Vector2(-direction.x, -1)
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
	$CollisionShape2D.set_deferred("disabled", true)

func _free_groups():
	if is_in_group("GeminiLaserSegmentP1"):
		remove_from_group("GeminiLaserSegmentP1")
	elif is_in_group("GeminiLaserSegmentP1"):
		remove_from_group("GeminiLaserSegmentP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
