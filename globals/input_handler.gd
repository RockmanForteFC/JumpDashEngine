extends Node

# Base class for handling user or AI inputs.
class_name InputHandler

enum Controller {
	EMPTY = 0,
	PLAYER_1 = 1,
	PLAYER_2 = 2,
	PLAYER_3 = 3,
	PLAYER_4 = 4
}

enum Action {
	UP,
	DOWN,
	RIGHT,
	LEFT,
	SHOOT,
	JUMP,
	SLIDE,
	WEAPON_NEXT,
	WEAPON_PREVIOUS,
#	QUICK_RESTART
}

var controller: int = Controller.EMPTY

func get_input_direction() -> Vector2:
	if controller == Controller.EMPTY:
		return Vector2.ZERO
	else:
		var right := int(Physics.is_action_pressed(_get_name(Action.RIGHT)))
		var left := int(Physics.is_action_pressed(_get_name(Action.LEFT)))
		var down := int(Physics.is_action_pressed(_get_name(Action.DOWN)))
		var up := int(Physics.is_action_pressed(_get_name(Action.UP)))
		return Vector2(right - left, down - up)

func is_action_released(action:int):
	var action_name: String = _get_name(action)
	if controller == Controller.EMPTY or action_name.empty():
		return false
	else:
		return Input.is_action_just_released(action_name)

func is_action_pressed(action: int) -> bool:
	var action_name: String = _get_name(action)
	if controller == Controller.EMPTY or action_name.empty():
		return false
	else:
		return Physics.is_action_pressed(action_name)

func is_action_just_pressed(action: int) -> bool:
	var action_name: String = _get_name(action)
	if controller == Controller.EMPTY or action_name.empty():
		return false
	else:
		return Input.is_action_just_pressed(action_name)

func emulate_command(command: String, state: State) -> void:
	if _can_handle_action(state):
		state._handle_command(command)

func _get_name(action: int) -> String:
	match action:
		Action.UP:
			return "action_up_p%s" % controller
		Action.DOWN:
			return "action_down_p%s" % controller
		Action.LEFT:
			return "action_left_p%s" % controller
		Action.RIGHT:
			return "action_right_p%s" % controller
		Action.SHOOT:
			return "action_shoot_p%s" % controller
		Action.JUMP:
			return "action_jump_p%s" % controller
		Action.SLIDE:
			return "action_slide_p%s" % controller
		Action.WEAPON_PREVIOUS:
			return "action_left_swap_p%s" % controller
		Action.WEAPON_NEXT:
			return "action_right_swap_p%s" % controller
#		Action.QUICK_RESTART:
#			return "action_quick_restart_p%s" % controller
		Action.HURT:
			return "action_quick_restart_p%s" % controller
		_:
			return ""

func _can_handle_action(state: State) -> bool:
	return !is_locked() and state and state.has_method("_handle_command")

func is_locked(with_charge_lock: bool = true) -> bool:
	return not (controller != Controller.EMPTY and owner.can_handle_action(with_charge_lock))
