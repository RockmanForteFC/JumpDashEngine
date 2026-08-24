extends "res://scenes/players/Mega Man/projectiles/projectile_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const RUSH_FLY_SPEED:float = 70.0
const RUSH_FLY_SLOW:float = 50.0
const RUSH_FLY_VERTICAL:float = 40.0
const FLY_AFTER_FRAMES = 5
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal rush_jet_ammo_tick(first_tick)
#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var ani:AnimationPlayer = $AnimationPlayer
onready var main_collision:CollisionShape2D = $CollisionShape2D
onready var down_front:RayCast2D = $CollisionShape2D/SpawnCheckDownFront
onready var down_back:RayCast2D = $CollisionShape2D/SpawnCheckDownBack
onready var left:RayCast2D = $CollisionShape2D/SpawnCheckLeft
onready var right:RayCast2D = $CollisionShape2D/SpawnCheckRight
onready var up:RayCast2D = $CollisionShape2D/SpawnCheckUp
onready var despawn_timer:Timer = $Timer
onready var detector = $rush_player_detector
onready var invalid_zone = $player_invalid_zone
onready var ammo_timer:Timer = $AmmoTimer
onready var flight_ceiling:RayCast2D = $flight_ceiling

var _player = null
var gravity_direction: Vector2 = Vector2.DOWN
var velocity:Vector2 = Vector2.ZERO
var _is_leaving:bool = false
var _did_perform_initial_checks:bool = false
var _is_ready:bool = false
var _is_flying:bool = false
var _was_deactivated:bool = false
var _first_tick:bool = true
var frame_count = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	main_collision.set_deferred("disabled",true)
	set_process(false)
	despawn_timer.connect("timeout",self,"despawn")
	ammo_timer.connect("timeout",self, "tick_ammo")

func _physics_process(delta):
	if not _did_perform_initial_checks:
		_did_perform_initial_checks = true
		if not is_obstructed():
			ani.play("Spawn_In")
		else:
			ani.play("Spawn_In_And_Out")
	else:
		if _is_ready and _is_flying and frame_count > FLY_AFTER_FRAMES:
			var new_position = Vector2(global_position.x + ((RUSH_FLY_SPEED * direction.x) * delta), global_position.y)
			if detector.overlaps_body(_player):
				if (_player and _player.is_feet_locked) and (direction.x >= 1 and Physics.is_action_pressed("action_left_p1")) or (direction.x <=-1 and Physics.is_action_pressed("action_right_p1")):
					new_position.x = global_position.x + ((RUSH_FLY_SLOW * direction.x) * delta)
				if Physics.is_action_pressed("action_up_p1"):
					if not flight_ceiling.is_colliding():
						new_position.y = global_position.y - (RUSH_FLY_VERTICAL * delta)
				elif Physics.is_action_pressed("action_down_p1"):
					if not down_front.is_colliding() and not down_back.is_colliding():
						new_position.y = global_position.y + (RUSH_FLY_VERTICAL * delta)
			if right.is_colliding():
				_deactivate()
			global_position = new_position
		frame_count += 1

func _process(delta):
	if _is_ready:
		for body in detector.get_overlapping_bodies():
			if body is Player and body.is_on_floor():
				_player = body
				if not  _is_flying:
					if not invalid_zone.overlaps_body(_player):
						_player.lock_feet()
						_is_flying = true
						_fly()
				elif _is_flying:
					_player.lock_feet()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func is_obstructed():
	if down_front.is_colliding() or down_back.is_colliding() or up.is_colliding() or left.is_colliding() or right.is_colliding():
		_is_leaving = true

func despawn():
	main_collision.set_deferred("disabled",true)
	_is_leaving = true
	ani.play("Touch_Down")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _fly():
	$player_invalid_zone/CollisionShape2D.set_deferred("disabled" ,true)
	flight_ceiling.enabled = true
	despawn_timer.stop()
	ammo_timer.start()

func _deactivate():
	set_process(false)
	set_physics_process(false)
	_was_deactivated = true
	ammo_timer.queue_free()
	despawn()
	_is_ready = false
	_is_flying = false
	PlayerValues.player.unlock_feet()


func queue_free():
	if !_was_deactivated:
		_deactivate()
	.queue_free()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func on_screen_leave():
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
			_is_ready = true
			main_collision.set_deferred("disabled",false)
			set_process(true)
			despawn_timer.start()
	elif anim_name == "Spawn_In_And_Out":
		queue_free()
	elif anim_name == "Spawn_Out":
		queue_free()


func _on_invalid_zone_body_entered(body):
	if body is Player:
		_is_ready = false

func _on_invalid_zone_body_exited(body):
		if body is Player:
			_is_ready = true

func tick_ammo():
	emit_signal("rush_jet_ammo_tick",_first_tick)
	if _first_tick:
		_first_tick = false
	ammo_timer.start()


func _on_rush_player_detector_body_exited(body):
	if body is Player:
		body.unlock_feet()
