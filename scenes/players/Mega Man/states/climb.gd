extends "megaman_common.gd"
#warning-ignore:return_value_discarded

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var collision_shape: CollisionShape2D = get_node("../../CollisionShape2D")

var direction: Vector2
var _is_move_anim = false
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
	owner.was_previously_in_slide = false
	owner.last_shooting_direction = owner.get_facing_direction()
	animation_player.play("Climb_Idle")
	owner.is_climbing = true
	owner.is_feet_locked = false

func _exit() -> void:
	_is_move_anim = false
	owner.is_climbing = false
	update_sprite_direction(direction if direction.x != 0 else owner.last_shooting_direction)

func _handle_command(command: String) -> void:
	if command == "shoot":
		if weapons.current_state.anim_name == "Non_Shoot":
			return
		emit_signal("finished", "climb_shoot")
	if command == "hold_shoot":
		hold_shoot("Climb_" + weapons.current_state.anim_name)
	if command == "drop_down":
		emit_signal("finished", "jump")
	if command.begins_with("weapon_"):
		weapons.change_weapon(command)

#warning-ignore:unused_argument
func _update(delta: float) -> void:
	if !owner.is_dead:
		if !owner.is_climb_locked == true:
			direction = get_input_direction()
			if direction.y != 0:
				if owner.ladder.is_exiting_ladder(owner):
					animation_player.play("Climb_Exit")
					if direction.y == -1:
						if owner.ladder.time_to_exit(owner):
							owner.global_position.y = owner.ladder.get_top() -15
				elif not _is_move_anim:
					_is_move_anim = true
					animation_player.play("Climb")
				
				# Exit when touching the floor while climbing.
				if sign(direction.y) == sign(owner.gravity_direction.y) and _will_touch_floor():
					emit_signal("finished", "idle")
				else:
					owner.move_and_slide(Vector2(0, direction.y * owner.climb_speed))
			else:
				_is_move_anim = false
				if owner.ladder.is_exiting_ladder(owner):
					animation_player.play("Climb_Exit")
				else:
					animation_player.play("Climb_Idle")

		if owner.charge_level > 0 and not weapons.is_holding_shoot():
			_handle_command("shoot")
		if weapons.current_state.is_holding_shoot():
			_handle_command("hold_shoot")

func _will_touch_floor() -> bool:
	var coll: KinematicCollision2D = owner.move_and_collide(Vector2(0, direction.y), true, true, true)
	return coll and coll.normal.is_equal_approx(-owner.gravity_direction)

#-------------------------------------------------
#      Connections
#-------------------------------------------------
