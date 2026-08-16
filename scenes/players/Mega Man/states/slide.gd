extends "on_ground.gd"
#warning-ignore:return_value_discarded


#-------------------------------------------------
#      Constants
#-------------------------------------------------
const DUST = preload("res://scenes/players/Mega Man/animations/Animation_Slide_Dust.tscn")
const LOCKED_FRAME_COUNT: int = 0
const SLIDE_SPEED: float = Physics.SLIDE_SPEED
const SLIDE_FRAME_COUNT: int = Physics.SLIDE_FRAMES
const SLIDE_POSITION_OFFSET:float = 6.0
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

onready var _slide_position: Position2D = owner.get_node("SlidePos")
onready var _ray_cast: RayCast2D = get_node("../../CollisionShape2D/RayCast2D")
onready var _ray_cast2: RayCast2D = get_node("../../CollisionShape2D/RayCast2D2")
onready var _ray_cast3: RayCast2D = get_node("../../CollisionShape2D/RayCast2D3")
onready var _ray_cast4: RayCast2D = get_node("../../CollisionShape2D/RayCast2D4")
var velocity: Vector2
var _frame_count: int
var _can_exit: bool
var _was_in_front_of_wall: bool
var _cancel_on_next_frame: bool
var slide_frames:int = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enter() -> void:
	if owner.stopper_ray_cast.is_colliding():
		_was_in_front_of_wall = true
		_cancel_on_next_frame = true
		return
	else:
		_was_in_front_of_wall = false
		_cancel_on_next_frame = false
	
	owner.was_previously_in_slide = true
	owner.is_sliding = true
	owner.buffering_charge = false
	_can_exit = false
	_ray_cast.enabled = true
	_ray_cast2.enabled = true
	_ray_cast3.enabled = true
	_ray_cast4.enabled = true
	animation_player.play("Slide")
	owner.emit_signal("action","slide")
	$"../../Sprite".offset.y = 2
	var facing_direction: Vector2 = owner.get_facing_direction()
	owner.stopper_ray_cast.cast_to = Vector2(12.5 * facing_direction.x, 0)
	velocity = Vector2()
	_frame_count = 0

	var dust = DUST.instance()
	
	# Slide dust animation
	dust.set_as_toplevel(true)
	dust.global_position = owner.global_position
	dust.scale.y = owner.scale.y
	if sprite.flip_h:
		dust.position = Vector2(dust.position.x +10, dust.position.y + owner.gravity_direction.y * 10)
		dust.face_left()
	else:
		dust.position = Vector2(dust.position.x -10, dust.position.y + owner.gravity_direction.y * 10)
		dust.face_right()
	owner.call_deferred("add_child", dust)
		
func _handle_command(command: String) -> void:
	if (command == "jump"
		and _can_exit
		and _frame_count >= LOCKED_FRAME_COUNT
		and (not inputs.is_action_pressed(InputHandler.Action.DOWN))
		):
			
		var ice_speed_modifier:float = 1
		if owner.has_low_friction:
			if owner.is_ready_frame_for_trail:
				owner.is_ready_frame_for_trail = false
				$"../../TrailFrameTimer".start()
				var t = TRAIL.instance()
				t.frame = $"../../Sprite".frame
				t.flip_h = $"../../Sprite".flip_h
				owner.get_parent().call_deferred("add_child",t)
				t.set_deferred("global_position",$"../../Sprite".global_position)
			ice_speed_modifier = owner.ICE_SPEED_MULTIPLIER
			owner.keep_momentum = true
		velocity.x = (SLIDE_SPEED * owner.get_facing_direction().x) * ice_speed_modifier
			
		emit_signal("finished", "jump")

	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

func _exit() -> void:
	$"../../Sprite".offset.y = 0
	slide_frames = 0
	$"../../slide".set_deferred("disabled", true)
	if _was_in_front_of_wall:
		return

	owner.is_sliding = false
	_ray_cast.enabled = false
	_ray_cast2.enabled = false
	_ray_cast3.enabled = false
	_ray_cast4.enabled = false
	owner.stopper_ray_cast.cast_to = Vector2(10.5*owner.get_facing_direction().x,0)

#warning-ignore:unused_argument
func _update(delta: float) -> void:
	if slide_frames == 3:
		var collision: CollisionShape2D = Physics.get_collision(owner)
		collision.position.x = sign(owner.get_facing_direction().x) * _slide_position.position.x
		$"../../slide".set_deferred("disabled", false)
	slide_frames += 1 
	if !owner.is_dead:
		if _cancel_on_next_frame:
			emit_signal("finished", "idle")
			return
		
		# Enough empty space above.
		_can_exit = !_ray_cast.is_colliding() and !_ray_cast2.is_colliding() and !_ray_cast3.is_colliding() and !_ray_cast4.is_colliding()

		velocity.y += owner.gravity
		var ice_speed_modifier:float = 1
		if owner.has_low_friction:
			if owner.is_ready_frame_for_trail:
				owner.is_ready_frame_for_trail = false
				$"../../TrailFrameTimer".start()
				var t = TRAIL.instance()
				t.frame = $"../../Sprite".frame
				t.flip_h = $"../../Sprite".flip_h
				owner.get_parent().call_deferred("add_child",t)
				t.set_deferred("global_position",$"../../Sprite".global_position)
			ice_speed_modifier = owner.ICE_SPEED_MULTIPLIER
		velocity.x = (SLIDE_SPEED * owner.get_facing_direction().x) * ice_speed_modifier
		velocity = owner.move_and_slide_with_snap(velocity, owner.snap, -owner.gravity_direction)

		# Full slide duration passed.
		var input_direction: Vector2 = get_input_direction()
		if _frame_count > SLIDE_FRAME_COUNT and _can_exit:
			if input_direction.x != 0 or owner.has_low_friction:
				emit_signal("finished", "move")
			else:
				emit_signal("finished", "idle")

		# Cancel slide by pressing the opposite direction.
		if _frame_count > LOCKED_FRAME_COUNT and _can_exit and \
				input_direction.x == -owner.get_facing_direction().x:
			emit_signal("finished", "move")

		if _frame_count > LOCKED_FRAME_COUNT and (not owner.is_on_floor() and not owner.is_on_ceiling()) and _can_exit:
			emit_signal("finished", "idle")
			
		if _frame_count > LOCKED_FRAME_COUNT and _can_exit and owner.stopper_ray_cast.is_colliding():
			emit_signal("finished", "idle")

		if not _can_exit:
			update_sprite_direction(input_direction)
		
		_frame_count += 1

func _should_soft_stun() -> bool:
	return _ray_cast.is_colliding() or _ray_cast2.is_colliding() or _ray_cast3.is_colliding() or _ray_cast4.is_colliding()

#-------------------------------------------------
#      Connections
#-------------------------------------------------

