extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHARK_BOOMERANG_SPEED = 340
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity:Vector2
var is_reflecting:bool = false
var is_returning:bool = false
var spawnPoint:Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	spawnPoint = global_position
	$Audio/shoot.play()
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	if !is_returning and !is_reflecting:
		move_and_slide((direction.normalized() * SHARK_BOOMERANG_SPEED), Vector2.UP)
	elif is_reflecting:
		move_and_slide((direction.normalized() * SHARK_BOOMERANG_SPEED), Vector2.UP)
	elif is_returning:
		direction =  PlayerValues.player.global_position - global_position
		move_and_slide((direction.normalized() * SHARK_BOOMERANG_SPEED), Vector2.UP)

func _process(delta):
	if did_hit_enemy:
		$RemoteTransform2D.remote_path = NodePath("")
		set_process(false)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func queue_free() -> void:
	hide()
	$RemoteTransform2D.remote_path = NodePath("")
	_free_groups()
	consumed = true
	if $Audio/shoot.playing:
		yield($Audio/shoot, "finished")
	.queue_free()
	
func reflect() -> void:
	is_reflecting = true
	_free_groups()
	$Audio/deflect.play()
	direction = Vector2(-direction.x, -1)
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	set_collision_mask_bit(Bitmask.enemy, false)
	set_collision_layer_bit(Bitmask.projectile, false)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _free_groups():
	if is_in_group("SharkBoomerangP1"):
		remove_from_group("SharkBoomerangP1")
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()

func _on_Timer_timeout():
	if !is_reflecting and !is_returning:
		is_returning = true
		$player_detector/CollisionShape2D.set_deferred("disabled",false)

func _on_pickup_detector_body_entered(body):
	if !did_hit_enemy:
		if !$RemoteTransform2D.remote_path:
			$pickup_detector/CollisionShape2D.set_deferred("disabled", true)
			$RemoteTransform2D.remote_path = body.get_path()

func _on_player_detector_body_entered(body):
	if body is Player:
		queue_free()
