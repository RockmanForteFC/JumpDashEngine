extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

export(float) var auto_fire_rate: float

var can_power_charge: bool = false

var _auto_fire_timer: Timer
var _auto_fire_mode: int

onready var weapons: StateMachine = get_parent()
onready var state_machine: Node = get_node("../../StateMachine")
onready var inputs: InputHandler = get_node("../../Inputs")

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if auto_fire_rate > 0.05:
		_set_auto_fire_mode(Config.auto_fire_mode)
		Config.connect("auto_fire_mode", self, "_set_auto_fire_mode")
		weapons.connect("player_shoot", self, "_on_player_shoot")
		_auto_fire_timer = Timer.new()
		_auto_fire_timer.wait_time = auto_fire_rate
		_auto_fire_timer.one_shot = true
		add_child(_auto_fire_timer)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func can_use() -> bool:
	return true

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _exit() -> void:
	_reset_auto_fire()

func _update(delta: float) -> void:
	if !_handle_auto_fire():
		_process_update(delta)

func _process_update(_delta: float) -> void:
	pass

func _handle_auto_fire() -> bool:
	if _can_handle_auto_fire() and !_should_ignore_auto_shot():
		if _auto_fire_timer.is_stopped() and can_use():
			match _auto_fire_mode:
				1: # Hold
					if inputs.is_action_pressed(InputHandler.Action.SHOOT):
						_try_auto_fire()
				3: # Toggle
					_try_auto_fire()
		return true
	return false

func _can_handle_auto_fire() -> bool:
	match _auto_fire_mode:
		1:
			return inputs.is_action_pressed(InputHandler.Action.SHOOT)
		2:
			if _is_shoot_action_just_pressed():
				_auto_fire_mode += 1
			return _auto_fire_mode > 2
		3:
			if _is_shoot_action_just_pressed():
				_auto_fire_mode -= 1
			return _auto_fire_mode > 2
	return false

func _should_ignore_auto_shot() -> bool:
	return can_power_charge and owner.charge_level > 0

func _try_auto_fire() -> void:
	if !_should_ignore_auto_shot():
		inputs.emulate_command("shoot", state_machine.current_state)

func _is_shoot_action_just_pressed() -> bool:
	return inputs.is_action_just_pressed(InputHandler.Action.SHOOT)

func _set_auto_fire_mode(val: int) -> void:
	_auto_fire_mode = val

func _reset_auto_fire() -> void:
	_auto_fire_mode = clamp(_auto_fire_mode, Config.AUTO_FIRE_MODE.off, Config.AUTO_FIRE_MODE.toggle)

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_player_shoot() -> void:
	if _auto_fire_mode and weapons.current_state == self:
		_auto_fire_timer.start()
