extends "res://scenes/players/Mega Man/states/jump.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const BOUNCE_VELOCITY = -400
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _enter() -> void:
	animation_player.play("Jump")
	velocity = Vector2(0,0)
	var bounce_vel = BOUNCE_VELOCITY * owner.gravity_direction.y
	velocity.y = bounce_vel - owner.gravity *2
	if not owner.is_bouncing:
		owner.is_bouncing = true

func _update(_delta) -> void:
	if !owner.is_dead:
		if owner.keep_momentum and !_speed_jump:
			_speed_jump = true
		if owner.charge_level > 0 and not weapons.is_holding_shoot():
			_handle_command("shoot")
		if inputs.is_action_pressed(InputHandler.Action.JUMP):
			pass

		var direction:Vector2 = get_input_direction()
		var _dir = update_sprite_direction(direction)
		
		var fall_speed: float = Physics.FALL_SPEED_MAX
		velocity.y = clamp(velocity.y + owner.gravity, 
			-fall_speed * (1.5 + 0.5 * owner.gravity_direction.y),
			fall_speed * (1.5 - 0.5 * owner.gravity_direction.y))
		
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
		owner.move_and_slide_with_snap(velocity, owner.snap, -owner.gravity_direction)
		
		if owner.is_on_floor():
			landing_sound.play()
			owner.is_bouncing = false
			emit_signal("finished", "idle")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
