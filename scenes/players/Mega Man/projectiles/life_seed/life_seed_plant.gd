extends KinematicBody2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SMALL_HEATH = preload("res://scenes/pickups/SmallHealth.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity: Vector2
var health_spawn_count = 0
var gravity_direction: Vector2 = Vector2.DOWN

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Spit_Timer.connect("timeout",self,"spawn_health")
	$AnimatedSprite.play("Grow")
	yield($AnimatedSprite,"animation_finished")
	$AnimatedSprite.play("Idle")
	spawn_health()

func _physics_process(_delta: float) -> void:
	velocity.x = 0.0
	velocity.y = clamp(velocity.y + gravity_direction.y * Physics.GRAVITY_HIGH,
		-Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	velocity = move_and_slide_with_snap(velocity, 16.0 * gravity_direction, -gravity_direction)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func spawn_health():
	if health_spawn_count == 4:
		queue_free()
	else:
		$AnimatedSprite.play("Spit")
		$spit.play()
		yield($AnimatedSprite,"animation_finished")
		var h = SMALL_HEATH.instance()
		h.is_upside_down = gravity_direction == Vector2.UP
		h.velocity = Vector2(
			-64 + (health_spawn_count * (Physics.TILE_SIZE.x * 3)),
			-135 * gravity_direction.y)
		h.can_despawn = true
		get_parent().call_deferred("add_child",h)
		h.set_deferred("global_position",$Position2D.global_position)
		$AnimatedSprite.play("Idle")
		health_spawn_count += 1 
		if health_spawn_count == 2:
			$AnimationPlayer.play("Flash")
		$Spit_Timer.start()
	
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_PreciseVisibilityNotifier2D_camera_exited():
	queue_free()
