extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal bounced_on_rush
#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var ani:AnimationPlayer = $AnimationPlayer
onready var down:RayCast2D = $CollisionShape2D/SpawnCheckDown
onready var left:RayCast2D = $CollisionShape2D/SpawnCheckLeft
onready var right:RayCast2D = $CollisionShape2D/SpawnCheckRight
onready var up:RayCast2D = $CollisionShape2D/SpawnCheckUp
onready var despawn_timer:Timer = $Timer
onready var detector = $spring_player_detector
onready var invalid_zone = $player_invalid_zone
onready var spring = $Spring/CollisionShape2D

var gravity_direction: Vector2 = Vector2.DOWN
var velocity:Vector2 = Vector2.ZERO
var _is_leaving:bool = false
var _did_perform_initial_checks:bool = false
var _has_found_floor:bool = false
var _is_ok_to_bounce:bool = true

#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	set_process(false)
	despawn_timer.connect("timeout",self,"despawn")

func _physics_process(delta):
	if not _did_perform_initial_checks:
		_did_perform_initial_checks = true
		if down.is_colliding():
			_has_found_floor = true
			velocity.y = gravity_direction.y * Physics.GRAVITY
			ani.play("Spawn_In")
		else:
			ani.play("Spawn_In_And_Out")
	else:
		if _has_found_floor:
			move_and_slide(velocity, -gravity_direction)
			if is_on_floor() or is_on_ceiling():
				velocity.y = gravity_direction.y * Physics.GRAVITY
			else:
				var grav = gravity_direction.y * Physics.GRAVITY
				velocity.y = clamp(velocity.y + grav, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)

func _process(delta):
	for body in detector.get_overlapping_bodies():
		if body is Player and (body.is_on_floor() or body.is_on_ceiling()) and _is_ok_to_bounce:
			ani.play("Bounce")
			body.on_rush_coil()
			emit_signal("bounced_on_rush")
			$Spring/CollisionShape2D.set_deferred("disabled",true)
			set_process(false)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func is_obstructed():
	if up.is_colliding() or left.is_colliding() or right.is_colliding():
		_is_leaving = true

func despawn():
	_is_leaving = true 
	ani.play("Touch_Down")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func on_screen_leave():
	if is_processing():
		queue_free()

func _on_animation_finished(anim_name):
	if anim_name == "Spawn_In":
		if is_obstructed():
			_is_leaving = true 
		if !_is_leaving:
			$WarpSound.play()
		ani.play("Touch_Down")
	elif anim_name == "Touch_Down":
		if _is_leaving:
			ani.play("Spawn_Out")
		else:
			ani.play("Idle")
			spring.disabled = false
			set_process(true)
			despawn_timer.start()
	elif anim_name == "Bounce":
		spring.disabled = true
		_is_leaving = true
		ani.play("Touch_Down")
	elif anim_name == "Spawn_In_And_Out":
		queue_free()
	elif anim_name == "Spawn_Out":
		queue_free()


func _on_invalid_zone_body_entered(body):
	if body is Player:
		_is_ok_to_bounce = false


func _on_invalid_zone_body_exited(body):
		if body is Player:
			_is_ok_to_bounce = true
