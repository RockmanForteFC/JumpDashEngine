extends "megaman_common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var velocity := Vector2()
var _velocity_init := Vector2()
var _speed_jump:bool = false

onready var landing_sound:AudioStreamPlayer = owner.get_node("Audio/Land")

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func preset(velocity_start: Vector2) -> void:
	_velocity_init = velocity_start
	if !owner.keep_momentum:
		if velocity_start.x < 0:
			velocity_start.x *= -1
		if velocity_start.x > 140.0:
			_speed_jump = true
			owner.keep_momentum = true
	else:
		_speed_jump = true
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	owner.unlock_feet()
	owner.was_previously_in_slide = false
	animation_player.play("Jump")
	velocity = _velocity_init
	_velocity_init = Vector2()
	
func _handle_command(command: String) -> void:
	if command == "jump_stop" and sign(velocity.y) == -sign(owner.gravity_direction.y) and not owner.is_bouncing:
		velocity.y = 0

	if command == "jump" and (PlayerValues.can_double_jump and owner.has_in_air_jump):
		owner.has_in_air_jump = false
		#use ceil to prevent any weird tileset culling
		velocity.y = ceil(Physics.JUMP_VELOCITY * 0.9)

	if command == "shoot":
		emit_signal("finished", "jump_shoot")
	if command == "hold_shoot":
		hold_shoot("Jump_" + weapons.current_state.anim_name)
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)
	
func _update(_delta) -> void:
	if !owner.is_dead:
		if owner.charge_level > 0 and not weapons.is_holding_shoot():
			_handle_command("shoot")
		if weapons.current_state.is_holding_shoot():
			_handle_command("hold_shoot")

		var direction:Vector2 = get_input_direction()
		var _dir = update_sprite_direction(direction)
		if owner.is_on_floor():
			owner.emit_signal("action","jump")
			var jump_vel = Physics.JUMP_VELOCITY * owner.gravity_direction.y
			velocity.y = jump_vel - owner.gravity *2
			
		var fall_speed = Physics.FALL_SPEED_MAX if owner.gravity != Physics.GRAVITY_WATER else Physics.FALL_SPEED_MAX_IN_WATER
		velocity.y = clamp(velocity.y + owner.gravity, 
			-fall_speed * (1.5 + 0.5 * owner.gravity_direction.y),
			fall_speed * (1.5 - 0.5 * owner.gravity_direction.y))
		# bonk if there is a tile "above" your head
		if owner.is_on_ceiling() and sign(velocity.y) == -sign(owner.gravity_direction.y):
			velocity.y = 0
		var speed_jump_multiplier:float = 1.0
		if _speed_jump:
			if owner.is_ready_frame_for_trail:
				owner.is_ready_frame_for_trail = false
				$"../../TrailFrameTimer".start()
				var t = TRAIL.instance()
				t.frame = $"../../Sprite".frame
				t.flip_h = $"../../Sprite".flip_h
				owner.get_parent().call_deferred("add_child",t)
				t.set_deferred("global_position",$"../../Sprite".global_position)
			speed_jump_multiplier = owner.ICE_SPEED_MULTIPLIER + .2
			
		velocity.x = owner.walking_speed * direction.x * speed_jump_multiplier
		owner.move_and_slide(velocity, -owner.gravity_direction)
	
	if owner.is_on_floor():
		landing_sound.play()
		owner.has_in_air_jump = true
		owner.is_bouncing = false
		_speed_jump = false
		emit_signal("finished", "idle")
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _exit():
	_speed_jump = false
