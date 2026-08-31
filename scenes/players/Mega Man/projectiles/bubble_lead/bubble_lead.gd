extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVE_SPEED = 110
const INITIAL_UPWARD_TRAJECTORY = -110
const INITIAL_MOVE_SPEED = 65
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var is_in_initial_arc:bool = true
var velocity:Vector2
var is_reflected:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if not $PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	$Audio/Shoot.play()
	velocity = Vector2( INITIAL_MOVE_SPEED * direction.x, INITIAL_UPWARD_TRAJECTORY)

func _process(delta):
	if !is_reflected:
		if is_in_initial_arc:
			velocity.y = clamp(velocity.y + 5, -Physics.FALL_SPEED_MAX,Physics.FALL_SPEED_MAX)
			move_and_slide(velocity,Vector2.UP)
			if is_on_ceiling():
				velocity.y = 0
			if is_on_floor():
				velocity.y = MOVE_SPEED
				is_in_initial_arc = false
		elif !is_in_initial_arc:
			move_and_slide(velocity,Vector2.UP)
			if is_on_floor():
				velocity.x = MOVE_SPEED * direction.x
				if is_on_wall():
					queue_free()
			else:
				velocity.x = 0
	else:
		velocity = direction * (MOVE_SPEED*2)
		move_and_slide(velocity,Vector2.UP)


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

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

func _free_groups():
	if is_in_group("BubbleLeadP1"):
		remove_from_group("BubbleLeadP1")
	elif is_in_group("BubbleLeadP1"):
		remove_from_group("BubbleLeadP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
