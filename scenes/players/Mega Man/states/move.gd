extends "on_ground.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TIPTOE_FRAME_COUNT: int = 5
const SHOOT_FRAME_COUNT_MAX: int = 19
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Vector2) var buster_position := Vector2(17, 4)
var _ice_frames:int = 0
var _walk_speed:float = 0
var _direction: Vector2
var _velocity: Vector2
var _frame_count: int
var _shoot_frame_count: int
var _tiptoe_frame_count: int
var _current_animation_pos: float
var stop_moving_when_shooting:bool = false
var _current_standstill_count:int = 0
var _standstill_frame_count:int = 10
var _velocity_init:Vector2 = Vector2.ZERO
var frame_count_init:int = -1
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func preset(presetVelocty = null):
	_direction = get_input_direction()
	_walk_speed = owner.walking_speed * _direction.x
	if presetVelocty:
		_velocity_init = presetVelocty
		var dir:Vector2
		if presetVelocty.x < 0:
			dir = Vector2.LEFT
		else:
			dir = Vector2.RIGHT
		_walk_speed = owner.walking_speed * dir.x
		frame_count_init = 1
	else:
		_velocity_init = Vector2()
		frame_count_init = -1
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	_velocity = _velocity_init
	_frame_count = frame_count_init
	_shoot_frame_count = SHOOT_FRAME_COUNT_MAX
	_tiptoe_frame_count = TIPTOE_FRAME_COUNT if owner.is_still else 0
	mega_buster.position = buster_position
	owner.was_previously_in_slide = false

func _exit() -> void:
	owner.is_still = false
	_walk_speed = 0
	_velocity_init = Vector2()
	frame_count_init = -1

func _handle_command(command: String) -> void:
	._handle_command(command)

	if command == "shoot" and _current_standstill_count == 0:
		if weapons.current_state.anim_name == "Kick":
			stop_moving_when_shooting = true
			shoot("Idle_" + weapons.current_state.anim_name,_current_animation_pos)
		else:

			if not animation_player.current_animation.begins_with("Move_Shoot"):
				_current_animation_pos = animation_player.current_animation_position
			if shoot("Move_" + weapons.current_state.anim_name,_current_animation_pos):
				_shoot_frame_count = -1
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

func _update(_delta: float) -> void:
	if !owner.is_dead:
		owner.moving_duration += _delta
		if stop_moving_when_shooting:
			_current_standstill_count += 1
			get_parent().locked = true
			if _current_standstill_count == _standstill_frame_count:
				get_parent().locked = false
				stop_moving_when_shooting = false
				_current_standstill_count = 0
			else:
				return

		_frame_count += 1
		_shoot_frame_count += 1
		_direction = get_input_direction()
		if owner.is_feet_locked:
			_direction.x = 0
		var _dir = update_sprite_direction(_direction)

		if _direction.x == 0 and _velocity.x == 0:
			if _walk_speed == 0:
				emit_signal("finished", "idle")
				return
		elif _frame_count == 0 and _shoot_frame_count > SHOOT_FRAME_COUNT_MAX:
			animation_player.play("TipToe")

		if owner.stopper_ray_cast.cast_to.x  < 0 and owner.get_facing_direction() == Vector2.RIGHT:
			owner.stopper_ray_cast.cast_to.x = owner.stopper_ray_cast.cast_to.x * -1
		elif owner.stopper_ray_cast.cast_to.x  > 0 and owner.get_facing_direction() == Vector2.LEFT:
			owner.stopper_ray_cast.cast_to.x = owner.stopper_ray_cast.cast_to.x * -1

		_velocity.y += owner.gravity

		if _frame_count < 1 and _tiptoe_frame_count > 0:
			_walk_speed = Physics.TIPTOE_SPEED * _direction.x
		elif _frame_count >= _tiptoe_frame_count:
			if owner.has_low_friction:
				if _direction.x == 0:
					if owner.has_low_friction and _walk_speed > 0:
						_walk_speed = clamp( _walk_speed - 1.75 , 0.0, _walk_speed)
					elif owner.has_low_friction and _walk_speed < 0:
						_walk_speed = clamp( _walk_speed + 1.75 , _walk_speed, 0.0)
				else:
					_walk_speed = clamp( _walk_speed + 2.5 * _direction.x, -owner.walking_speed, owner.walking_speed)
			else:
				_walk_speed = owner.walking_speed * _direction.x
		else:
			_walk_speed = 0

		_velocity.x = _walk_speed

		_velocity = owner.move_and_slide_with_snap(_velocity, owner.snap, -owner.gravity_direction)

		if _direction.x != 0:
			if _frame_count >= _tiptoe_frame_count and _shoot_frame_count > SHOOT_FRAME_COUNT_MAX and \
					animation_player.current_animation != "Move":
				_current_animation_pos = animation_player.current_animation_position
				animation_player.play("Move")
				animation_player.seek(_current_animation_pos, true)
		else:
			pass
			#animation_player.play("Idle")

		if not owner.is_on_floor():
			emit_signal("finished", "jump")

		if owner.charge_level > 0 and not weapons.is_holding_shoot():
			_handle_command("shoot")

#-------------------------------------------------
#      Connections
#-------------------------------------------------
