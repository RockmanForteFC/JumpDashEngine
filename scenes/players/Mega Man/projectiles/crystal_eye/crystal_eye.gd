extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const EYE_SPEED:float = 196.0
const LITTLE_BALL:Resource = preload("res://scenes/players/Mega Man/projectiles/crystal_eye/little_ball/little_ball.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$AnimatedSprite.play("default")
	$Audio/shoot.play()
func _physics_process(delta):
	move_and_slide((direction.normalized() * EYE_SPEED),Vector2.UP)
	if is_on_wall() or did_hit_enemy:
		split()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func split():
	set_physics_process(false)
	hide()
	var lb = LITTLE_BALL.instance()
	var dr
	get_parent().call_deferred("add_child", lb)
	if direction.x == Vector2.LEFT.x:
		dr = Vector2.RIGHT.x
	elif direction.x == Vector2.RIGHT.x:
		dr = Vector2.LEFT.x
	lb.direction.x = dr
	lb.set_deferred("global_position", global_position)

	var lb2 = LITTLE_BALL.instance()
	var dr2
	get_parent().call_deferred("add_child", lb2)
	if direction.x == Vector2.LEFT.x:
		dr2 = Vector2.RIGHT.x
	elif direction.x == Vector2.RIGHT.x:
		dr2 = Vector2.LEFT.x
	lb2.direction.x = dr2
	lb2.direction.y = Vector2.DOWN.y
	lb2.set_deferred("global_position", global_position)

	var lb3 = LITTLE_BALL.instance()
	var dr3
	get_parent().call_deferred("add_child", lb3)
	if direction.x == Vector2.LEFT.x:
		dr3 = Vector2.RIGHT.x
	elif direction.x == Vector2.RIGHT.x:
		dr3 = Vector2.LEFT.x
	lb3.direction.x = dr3
	lb3.direction.y = Vector2.UP.y
	lb3.set_deferred("global_position", global_position)
	queue_free()
func queue_free() -> void:
	_free_groups()
	consumed = true
	if $Audio/shoot.playing:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		yield($Audio/shoot, "finished")
	.queue_free()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("CrystalEyeP1"):
		remove_from_group("CrystalEyeP1")

func reflect() -> void:
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_mask_bit(Bitmask.stage, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
