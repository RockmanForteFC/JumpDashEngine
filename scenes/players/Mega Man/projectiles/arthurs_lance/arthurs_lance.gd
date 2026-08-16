extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const MOVE_SPEED = 250
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
	if direction == Vector2.LEFT:
		scale.x *= -1
	if not $PreciseVisibilityNotifier2D.is_on_screen():
		queue_free()
	$Audio/Shoot.play()
	velocity = Vector2( MOVE_SPEED * direction.x, 0)

func _physics_process(delta: float) -> void:
	var _move = move_and_collide(direction.normalized() * MOVE_SPEED * delta)
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
	_free_groups()
	$Audio/Reflect.play()
	direction = Vector2(-direction.x, -1)
	$Sprite.flip_h = !$Sprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
	
func _free_groups():
	if is_in_group("ArthursLanceP1"):
		remove_from_group("ArthursLanceP1")
	elif is_in_group("ArthursLanceP1"):
		remove_from_group("ArthursLanceP1")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
