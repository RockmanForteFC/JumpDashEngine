extends Node

signal enemies_paused(value)

const TIMER_WAIT_TIME_MIN_THRESHOLD: float = 0.05
const TILE_SIZE := Vector2(16, 16)

const WALKING_SPEED:float = 90.0
const JUMP_VELOCITY:float = -285.0
const SLIDE_SPEED:float = 140.0
const CLIMB_SPEED:float = 78.0
const CLIMB_EXIT_SPEED:float = 50.0

const SPEED_BOOST:float = 50.0

const ENEMY_IDLE_GRAVITY:float = 10.0
const GRAVITY:float = 15.0
const GRAVITY_MAELSTROM:float = GRAVITY / 1.8
const GRAVITY_WATER:float = GRAVITY / 2.9
const GRAVITY_SPACE:float = GRAVITY / 3.5
const GRAVITY_HIGH:float =  GRAVITY * 1.8

const DAMAGE_ON_SPIKES_WHEN_PLAYER_HAS_PROTECTION:int = 5

const DIRECTION_LEFT:int = -1
const DIRECTION_RIGHT:int = 1
const SLIDE_FRAMES:int = 20
const DAMAGE_PUSH_BACK_FRAMES = 30
const DAMAGE_PUSHBACK_DISTANCE:float = 20.0
const FALL_SPEED_MAX: float = 420.0
const FALL_SPEED_MAX_IN_WATER:float = 280.0
#tiptoe is 60 because at FPS60 you get 1 frame of tiptoe
const TIPTOE_SPEED:float = 60.0

const CHARGE_DURATION_LVL1:float = 0.4
const CHARGE_DURATION_LVL2:float = 1.5
const CHARGE_DURATION_LVL3:float = 3.0

const SINGLE_SHOT_SPEED:float = 250.0
const CHARGED_SHOT_SPEED:float = 320.0
const CHARGED_SHOT_DAMAGE:int = 3
const UPGRADED_CHARGED_SHOT_DAMAGE:int = 5

const MENU_FADE_TIME:float = 0.35
const PAUSE_FADE_TIME:float = 0.1
const SKIP_CUTSCENE_TIMER:float = 1.25

const NOTIFICATION_CHILD_PHYSICS_BODY_TRANSFORM_CHANGED: int = 2001
const WORLD_GRAVITY_DIRECTION: Vector2 = Vector2.DOWN
const _NO_BODIES: Array = []

var is_in_pausible_state := false
var is_pause_enabled := false
var is_game_paused := false
var bar_fill_pause := false

#used in giant gabyoall to spawn platforms
var is_boss_active:bool = false

var is_in_boss_fight:bool = false
var current_stage: Stage
var top_tile_of_screen_view:float = 0.0
var enemies_count: Dictionary = {}
var lever_state = 0
var pause_enemies:bool = false setget set_pause_enemies
enum Damage {contact,projectile,screen_wide,hazard,spike,}
enum Element {fire,water,electric,ground,leaf, neutral, chemical, blade, ice, wind, dark, light}
var item_despawn_rate:float = 1.0
# used for item drops
var rng = RandomNumberGenerator.new()
# for challenges
var challenge_id:int
var endless_id:int = 1
func _ready():
	rng.randomize()
	pause_mode = PAUSE_MODE_PROCESS

const LEFT_STICK_DEADZONE := 0.5
const LEFT_STICK_DIRECTION_DEBOUNCE := 0.25

const UI_STICK_ACTIONS := ["ui_up", "ui_down", "ui_left", "ui_right"]

var _stick_direction_last_trigger := {}
var _stick_direction_was_pressed := {}

func _process(_delta):
	if _should_inject_stick_as_ui_actions():
		_poll_stick_as_ui_actions()

func is_action_pressed(action: String) -> bool:
	# Temporary workaround until the following engine issue will be fixed.
	# https://github.com/godotengine/godot/issues/45628

	var is_pressed := false
	for event in InputMap.get_action_list(action):
		if event is InputEventKey:
			is_pressed = Input.is_key_pressed(event.scancode)
		elif event is InputEventJoypadButton:
			is_pressed = Input.is_joy_button_pressed(event.device, event.button_index)
		elif event is InputEventMouseButton:
			is_pressed = Input.is_mouse_button_pressed(event.button_index)
		elif event is InputEventJoypadMotion:
			is_pressed = true if Input.get_action_strength(action) > 0 else false
		# Add more elif to treat the type accordingly.
		else:
			continue

		if is_pressed:
			break

	if not is_pressed:
		is_pressed = _is_left_stick_direction_pressed(action)

	return is_pressed

func _should_inject_stick_as_ui_actions() -> bool:
	if not Config.analog_movement_enabled:
		return false
	if is_game_paused:
		return true
	var scene = get_tree().current_scene
	if scene != null and scene.filename.begins_with("res://scenes/menus/"):
		return true
	if scene != null and scene.filename.begins_with("res://scenes/cut_scene/"):
		return true
	return false

func _poll_stick_as_ui_actions(device: int = 0) -> void:
	for ui_action in UI_STICK_ACTIONS:
		var is_pressed_now := _is_ui_stick_direction_pressed(ui_action, device)
		if _is_left_stick_direction_debounced(ui_action, is_pressed_now, LEFT_STICK_DIRECTION_DEBOUNCE):
			_inject_ui_action(ui_action)

func _inject_ui_action(action: String) -> void:
	Input.action_press(action)
	var press_event = InputEventAction.new()
	press_event.action = action
	press_event.pressed = true
	Input.parse_input_event(press_event)
	call_deferred("_release_ui_action", action)

func _release_ui_action(action: String) -> void:
	Input.action_release(action)
	var release_event = InputEventAction.new()
	release_event.action = action
	release_event.pressed = false
	Input.parse_input_event(release_event)

func _is_ui_stick_direction_pressed(ui_action: String, device: int = 0) -> bool:
	# Reached only via _poll_stick_as_ui_actions(), which already gates on analog_movement_enabled.
	var axis_x := Input.get_joy_axis(device, JOY_AXIS_0)
	var axis_y := Input.get_joy_axis(device, JOY_AXIS_1)
	match ui_action:
		"ui_left":
			return axis_x < -LEFT_STICK_DEADZONE
		"ui_right":
			return axis_x > LEFT_STICK_DEADZONE
		"ui_up":
			return axis_y < -LEFT_STICK_DEADZONE
		"ui_down":
			return axis_y > LEFT_STICK_DEADZONE
		_:
			return false

func _is_left_stick_direction_pressed(action: String, device: int = 0) -> bool:
	if not Config.analog_movement_enabled:
		return false
	if is_game_paused:
		return false
	if not action in ["action_up_p1", "action_down_p1", "action_left_p1", "action_right_p1"]:
		return false
	var axis_x := Input.get_joy_axis(device, JOY_AXIS_0)
	var axis_y := Input.get_joy_axis(device, JOY_AXIS_1)
	match action:
		"action_left_p1":
			return axis_x < -LEFT_STICK_DEADZONE
		"action_right_p1":
			return axis_x > LEFT_STICK_DEADZONE
		"action_up_p1":
			return axis_y < -LEFT_STICK_DEADZONE
		"action_down_p1":
			return axis_y > LEFT_STICK_DEADZONE
		_:
			return false

func is_action_just_pressed(action: String, stick_debounce: float = 0.0, stick_debounce_group: String = "") -> bool:
	if Input.is_action_just_pressed(action):
		return true
	if stick_debounce <= 0.0:
		return false
	return _is_left_stick_direction_debounced(action, _is_left_stick_direction_pressed(action), stick_debounce, stick_debounce_group)

func _is_left_stick_direction_debounced(direction_key: String, is_pressed_now: bool, debounce: float, debounce_group: String = "") -> bool:
	var was_pressed: bool = _stick_direction_was_pressed.get(direction_key, false)
	_stick_direction_was_pressed[direction_key] = is_pressed_now
	if not is_pressed_now or was_pressed:
		return false
	var debounce_key := debounce_group if debounce_group else direction_key
	var now := OS.get_ticks_msec() / 1000.0
	var last_trigger: float = _stick_direction_last_trigger.get(debounce_key, -debounce)
	if now - last_trigger < debounce:
		return false
	_stick_direction_last_trigger[debounce_key] = now
	return true


func get_action_strength(action: String) -> float:
	# Temporary workaround until the following engine issue will be fixed.
	# https://github.com/godotengine/godot/issues/45628

	var action_strength := Input.get_action_strength(action)
	if action_strength == 0:
		action_strength = 1 if is_action_pressed(action) else 0

	return action_strength

func get_walking_speed()->float:
	return WALKING_SPEED

func get_jump_velocity()->float:
	return JUMP_VELOCITY

func increase_enemy_count(enemy_name: String) -> void:
	if not enemies_count.has(enemy_name):
		enemies_count[enemy_name] = 0
	enemies_count[enemy_name] += 1


func decrease_enemy_count(enemy_name: String) -> void:
	if enemies_count.has(enemy_name):
		enemies_count[enemy_name] -= 1

		if enemies_count[enemy_name] < 0:
			printerr("Enemy Count (%s) is smaller than 0: %s" % [enemy_name, enemies_count[enemy_name]])

func get_enemy_count(enemy_name: String) -> int:
	if enemies_count.has(enemy_name):
		return enemies_count[enemy_name]
	else:
		return 0

func reset_enemy_count() -> void:
	Physics.enemies_count.clear()

func set_pause_enemies(value: bool) -> void:
	pause_enemies = value
	emit_signal("enemies_paused", value)

# Convinience method to get overlapping bodies when area is not monitoring to avoid error spam in logs
static func get_overlapping_bodies(area: Area2D) -> Array:
	return area.get_overlapping_bodies() if area.monitoring else _NO_BODIES

# Convinience method to get collision (CollisionShape2D / CollisionPolygon2D) or Area2D / PhysicsBody2D
static func get_collision(body: CollisionObject2D, owner_index: int = 0) -> Object:
	return body.shape_owner_get_owner(body.get_shape_owners()[owner_index])

static func attach_ui_to_player(ui_node: CanvasItem) -> void:
	var player: Player = PlayerValues.player
	if not is_instance_valid(player):
		player = yield(PlayerValues, "player_instanced")
	if is_instance_valid(ui_node) and not ui_node.is_queued_for_deletion():
		var mover: RemoteTransform2D = RemoteTransform2D.new()
		ui_node.connect("tree_exited", Physics, "_on_ui_node_exited", [ ui_node, mover ])
		mover.update_scale = false
		mover.update_rotation = false
		mover.remote_path = ui_node.get_path()
		player.add_child(mover)
		ui_node.set_as_toplevel(true)

static func _on_ui_node_exited(ui_node: CanvasItem, mover: RemoteTransform2D) -> void:
	if ui_node.is_queued_for_deletion():
		mover.queue_free()

static func x_speed_aim(from: Vector2, to: Vector2, y_speed: float, \
		gravity: float, speed_limit: float = -1.0, move_full_arc: bool = true, \
		limit_to_axis: bool = true, axis: int = Vector2.AXIS_X) -> float:
	"""
	Calculate number of steps to reach destination y using the equation:
	Yn = Y0 + (Vy + g)*dt + (Vy + 2*g)*dt + ... + (Vy + n*g)*dt ->
	Yn = Y0 + (n*Vy + n*(n + 1)*g / 2)*dt, where:
	Yn - destination y position component
	Y0 - source y position component
	Vy - y velocity component
	dt - delta time step
	g  - gravity
	n  - number of steps suppose to be found
	"""
	var op_axis: int = 1 - axis
	if limit_to_axis:
		to[op_axis] = max(from[op_axis], to[op_axis])
	var delta: Vector2 = to - from
	var dt: float = Physics.get_physics_process_delta_time()
	var a: float = gravity
	var b: float = 2.0 * y_speed + gravity
	var c: float = -2.0 * delta[op_axis] / dt
	var discr: float = pow(b, 2.0) - 4.0 * a * c
	# TODO remove debugging stuff once we sure function works well
	# warning-ignore:unassigned_variable
	#var roots: PoolRealArray
	#if discr == 0.0:
	#	roots.push_back((-b + sqrt(discr)) / (2.0 * a))
	#elif discr > 0.0:
	#	roots.push_back((-b + sqrt(discr)) / (2.0 * a))
	#	roots.push_back((-b - sqrt(discr)) / (2.0 * a))

	var steps: float = 0.0 if discr < 0.0 else \
		(-b + float(move_full_arc) * sqrt(discr)) / (2.0 * a)
	var result: float = (delta[axis] / steps / dt if steps else \
		sign(delta[axis]) * abs(y_speed)) * (2.0 * (1.0 - axis) - 1.0)
	return result if speed_limit == -1.0 else \
		sign(result) * min(abs(result), abs(speed_limit))

static func y_speed_aim(from: Vector2, to: Vector2, motion: Vector2, \
		gravity: float, speed_limit: float = -1.0, axis: int = Vector2.AXIS_Y) -> float:
	"""
	Calculate number of steps to reach destination y using the equation:
	Yn = Y0 + (Vy + g)*dt + (Vy + 2*g)*dt + ... + (Vy + n*g)*dt ->
	Yn = Y0 + (n*Vy + n*(n + 1)*g / 2)*dt, where:
	Yn = Y0 + (Vy + (n + 1)*g / 2)*n*dt ->
	Vy = (Yn - Y0) / n*dt - (n + 1)*g / 2, where
	Yn - destination y position component
	Y0 - source y position component
	dt - delta time step
	n  - number of steps
	g  - gravity
	Vy - y velocity component suppose to be found
	"""
	var dt: float = Physics.get_physics_process_delta_time()
	var result: float = get_velocity_by_steps_number(\
		get_pass_time(from, to, motion)[1 - axis] / dt, to[axis] - from[axis], \
		gravity, dt)
	return result if speed_limit == -1.0 else \
		sign(result) * min(abs(result), abs(speed_limit))

static func get_velocity_by_steps_number(n: float, distance: float, \
		gravity: float, \
		dt: float = Physics.get_physics_process_delta_time()) -> float:
	return distance / (n * dt) - (n + 1.0) * gravity / 2.0

static func get_y_destination_time(from: Vector2, to: Vector2, \
		y_speed: float, gravity: float, move_full_arc: bool = true) -> float:
	var delta: Vector2 = to - from
	var dt: float = Physics.get_physics_process_delta_time()
	var a: float = gravity
	var b: float = 2.0 * y_speed + gravity
	var c: float = -2.0 * delta.y / dt
	var discr: float = pow(b, 2.0) - 4.0 * a * c
	return (0.0 if discr < 0.0 else \
		(-b + (2.0 * float(move_full_arc) - 1.0) * sqrt(discr)) / (2.0 * a)) * dt

static func get_pass_time(p1: Vector2, p2: Vector2, motion: Vector2) -> Vector2:
	var result: Vector2 = Vector2.INF
	var delta: Vector2 = (p1 - p2).abs()
	if motion.x:
		result.x = delta.x / abs(motion.x)
	if motion.y:
		result.y = delta.y / abs(motion.y)
	return result

static func calculate_time_to_reach_velocity(vel_current: float, \
		vel_target: float, gravity: float) -> float:
	var delta: float = vel_target - vel_current
	return INF if delta < 0.0 else delta / gravity * \
		Physics.get_physics_process_delta_time()

static func y_speed_straight(from: Vector2, to: Vector2, \
		target_y_speed: float, gravity: float, \
		move_full_arc: bool = true, axis: int = Vector2.AXIS_Y) -> float:
	"""
	Calculate number of steps to reach destination y using the equation:
	Yn = Y0 + (Vy + g)*dt + (Vy + 2*g)*dt + ... + (Vy + n*g)*dt,
	Vy + n*g = Vt -> n = (Vt - Vy) / g ->
	Yn = Y0 + (n*Vy + n*(n + 1)*g / 2)*dt ->
	Yn = Y0 + (Vy + (n + 1)*g / 2)*n*dt ->
	Yn - Y0 = (Vy + ((Vt - Vy) / g + 1)*g / 2) * (Vt - Vy)*dt / g ->
	Yn - Y0 = (Vy*g + ((Vt - Vy + g) / g)*g / 2) * (Vt - Vy)*dt / g ->
	Yn - Y0 = ((2*Vy*g + Vt - Vy + g) / 2) * (Vt - Vy)*dt / g ->
	2*g*(Yn - Y0) / dt = (Vt + Vy + g) * (Vt - Vy) ->
	2*g*(Yn - Y0) / dt = Vt^2 - Vt*Vy + Vt*Vy - Vy^2 + g*Vt - g*Vy
	2*g*(Yn - Y0) / dt = -Vy^2 - g*Vy + Vt^2 + g*Vt, where
	Yn - destination y position component
	Y0 - source y position component
	dt - delta time step
	n  - number of steps
	g  - gravity
	Vt - target y velocity component
	Vy - y velocity component suppose to be found
	"""
	var dt: float = Physics.get_physics_process_delta_time()
	var a: float = -1.0
	var b: float = -gravity
	var c: float = pow(target_y_speed, 2.0) + target_y_speed * gravity - \
		2.0 * gravity * (to[axis] - from[axis]) / dt
	var discr: float = pow(b, 2.0) - 4.0 * a * c
	return 0.0 if discr < 0.0 else \
		(-b + float(move_full_arc) * sqrt(discr)) / (2.0 * a)
