extends InputHandler


func _unhandled_input(event: InputEvent) -> void:
	if _can_handle_action(_get_state()):
		if Config.is_down_jump_enabled and \
				(event.is_action_pressed(_get_name(Action.JUMP)) and \
				is_action_pressed(Action.DOWN if not owner.is_upside_down else Action.UP)):
			_get_state()._handle_command("slide")
		elif Input.is_action_just_pressed(_get_name(Action.SLIDE)):
			# Using Input.is_action_just_pressed() for touch buttons to prevent continuous input events.
			_get_state()._handle_command("slide")

		if event.is_action_pressed(_get_name(Action.JUMP)):
			_get_state()._handle_command("jump")
		
		if event.is_action_released(_get_name(Action.JUMP)):
			_get_state()._handle_command("jump_stop")

		if event.is_action_pressed(_get_name(Action.SHOOT)):
			_get_state()._handle_command("shoot")

		if event.is_action_pressed(_get_name(Action.JUMP)) and \
				not is_action_pressed(Action.UP) and \
				not is_action_pressed(Action.DOWN):
			_get_state()._handle_command("drop_down")

		if Config.weapon_wheel_enabled \
				and event is InputEventJoypadButton \
				and event.pressed \
				and event.button_index == JOY_BUTTON_9:
			_get_state()._handle_command("weapon_buster")

		if Config.weapon_wheel_enabled \
				and event is InputEventKey \
				and event.pressed \
				and not event.is_echo() \
				and event.scancode == KEY_KP_5:
			_get_state()._handle_command("weapon_buster")

		# 1. Check if NEXT was just pressed, while PREVIOUS is already held
		if event.is_action_pressed(_get_name(Action.WEAPON_NEXT)) and Input.is_action_pressed(_get_name(Action.WEAPON_PREVIOUS)):
			_get_state()._handle_command("weapon_buster")

		# 2. Check if PREVIOUS was just pressed, while NEXT is already held
		elif event.is_action_pressed(_get_name(Action.WEAPON_PREVIOUS)) and Input.is_action_pressed(_get_name(Action.WEAPON_NEXT)):
			_get_state()._handle_command("weapon_buster")

		# 3. Fallbacks for single presses (Use ELIF so they don't fire if the combo worked)
		elif event.is_action_pressed(_get_name(Action.WEAPON_NEXT)):
			_get_state()._handle_command("weapon_next")

		elif event.is_action_pressed(_get_name(Action.WEAPON_PREVIOUS)):
			_get_state()._handle_command("weapon_previous")
			


func send(command: String) -> void:
	if _get_state():
		_get_state()._handle_command(command)

func _get_state() -> State:
	return $"../StateMachine".current_state
