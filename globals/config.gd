extends "uuid.gd"

enum AUTO_FIRE_MODE {
	off, hold, toggle,
}

# Note: Mega Man's base window size is 256 x 224.
# Max scale factor N is adaptive and depends on display screen resolution
#		window_size 0: Fullscreen
# 		window_size 1..N: (256*N x 224*N)

signal size_changed()
signal http_request_done
signal time_trial_retrieved(time)
signal time_trial_ghost_retrieved(ghost)
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const WINDOW_FULL_SCREEN: int = 0
const DEFAULT_WINDOW_WIDTH = 256
const DEFAULT_WINDOW_HEIGHT = 224
const APP_FOLDER = "user://"
const CONFIG_VERSION = "1.0.0"

const DEFAULTS: Dictionary = {
	auto_fire_mode = AUTO_FIRE_MODE.off,
	auto_charge_enabled = false,
	window_size = 2,
}

#-------------------------------------------------
#      properties
#-------------------------------------------------
var CONFIG_FILE_LOCAL = ""
var BUTTON_MAPPINGS_FILE = ""
var SECURITY_KEY = "FIBSFN3434NIND"

var window_size: int = DEFAULTS.window_size setget _set_window_size
var language = "ENG"
var die_on_spikes:bool = true
var default_lives:int = 2
var show_damage_values:bool = false
var global_config = {}
var is_down_jump_enabled:bool = true
var show_filters:bool = true
var clear_projectiles_on_swap:bool = true
var has_beat_game:bool = false
var highest_rank:String = "?"
var total_accumulated_playtime:float = 0.0
var is_player_new_to_game:bool = true
var high_endless:int = 0
var high_rogue:int = 0
var is_rogue_unlocked:bool = false
var pause_on_health_pickup:bool = false
var skip_boss_dialog:bool = false
var midgame_cutscene_seen:bool = false
var all_robot_cutscene_seen:bool = false
var lienient_timings:bool = false
var show_Bolts_on_pickup:bool = false
var auto_fire_mode: int = DEFAULTS.auto_fire_mode
var auto_charge_enabled: bool = DEFAULTS.auto_charge_enabled
var show_score_display: bool = false
var time_trial_ghosts_enabled: bool = true
var analog_movement_enabled: bool = true
var weapon_wheel_enabled: bool = true
var extra_checkpoints:bool = false
var locale:String = ""
# for time trials and challenges to be unlocked.
var is_intro_unlocked:bool = false
var is_ninja_unlocked:bool = false
var is_tremor_unlocked:bool = false
var is_arctic_unlocked:bool = false
var is_beam_unlocked:bool = false
var is_detonate_unlocked:bool = false
var is_incinerate_unlocked:bool = false
var is_maelstrom_unlocked:bool = false
var is_gladiator_unlocked:bool = false
var is_serenade_unlocked:bool = false
var is_virus_1_unlocked:bool = false
var is_virus_2_unlocked:bool = false
var is_virus_3_unlocked:bool = false
var is_virus_4_unlocked:bool = false
var is_wily_1_unlocked:bool = false
var is_wily_2_unlocked:bool = false
var is_wily_3_unlocked:bool = false
var is_wily_4_unlocked:bool = false
var is_wily_5_unlocked:bool = false

# this is not saved. this is only for after you clear the game
var was_game_just_cleared:bool = false

enum VOLUME {
	mute = -80,
	one = -50,
	two = -30,
	three = -25,
	four = -10,
	five = -05
	}
var music_volume:int = VOLUME.four
var sound_effect_volume:int = VOLUME.four

# maybe there will be leaderboards?
var player_name = ""
var player_id = ""

var _is_timer_running = false

#-------------------------------------------------
#      processes
#-------------------------------------------------
func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	var prefix = ""
	CONFIG_FILE_LOCAL =  APP_FOLDER + prefix +  ProjectSettings.get_setting("application/config/config") + ".cnf"
	BUTTON_MAPPINGS_FILE =  APP_FOLDER + prefix +  ProjectSettings.get_setting("application/config/controller_mappings") + ".cnf"
	_add_settings_changed_signals()
	load_buttons_file()
	load_config()
	set_volume()
	set_window_size()
	_is_timer_running = true
	if player_name == "DEFAULT_USER":
		if player_id == "":
			player_id = v4()

# Handles the button presses for global keys F1-F4
func _process(delta):
	if _is_timer_running:
		total_accumulated_playtime += delta
	if Input.is_action_just_pressed("window_size_smaller"):
		wrap_window_size(-1)
	elif Input.is_action_just_pressed("window_size_bigger"):
		wrap_window_size(1)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func load_config_from_file():
	var file = File.new()
	file.open_encrypted_with_pass(CONFIG_FILE_LOCAL, File.READ, SECURITY_KEY)
	var content = file.get_as_text()
	var parse_result = JSON.parse(content)
	if(parse_result.error == OK):
		global_config = parse_result.result
		_set_or_default(global_config, "window_size")
		die_on_spikes = global_config.die_on_spikes if global_config.has("die_on_spikes") else true
		default_lives = global_config.default_lives if global_config.has("default_lives") else 2
		show_damage_values = global_config.show_damage if global_config.has("show_damage") else false
		is_down_jump_enabled = global_config.is_down_jump_enabled if global_config.has("is_down_jump_enabled") else true
		music_volume = global_config.bgm if global_config.has("bgm") else -20
		sound_effect_volume = global_config.sfx if global_config.has("sfx") else -20
		has_beat_game = global_config.has_beat_game if global_config.has("has_beat_game") else false
		highest_rank  = global_config.highest_rank if global_config.has("highest_rank") else "?"
		total_accumulated_playtime = global_config.total_accumulated_playtime if global_config.has("total_accumulated_playtime") else 0
		player_name = global_config.player_name if global_config.has("player_name") else "DEFAULT_USER"
		player_id = global_config.player_id if global_config.has("player_id") else v4()
		is_player_new_to_game = global_config.is_player_new_to_game if global_config.has("is_player_new_to_game") else true
		show_filters = global_config.show_filters if global_config.has("show_filters") else true
		pause_on_health_pickup = global_config.pause_on_health_pickup if global_config.has("pause_on_health_pickup") else false
		skip_boss_dialog = global_config.skip_boss_dialog if global_config.has("skip_boss_dialog") else false
		midgame_cutscene_seen =  global_config.midgame_cutscene_seen if global_config.has("midgame_cutscene_seen") else false
		all_robot_cutscene_seen = global_config.all_robot_cutscene_seen if global_config.has("all_robot_cutscene_seen") else false
		lienient_timings = global_config.lienient_timings if global_config.has("lienient_timings") else false
		show_Bolts_on_pickup = global_config.show_Bolts_on_pickup if global_config.has("show_Bolts_on_pickup") else false
		show_score_display = global_config.show_score_display if global_config.has("show_score_display") else false
		time_trial_ghosts_enabled = global_config.time_trial_ghosts_enabled if global_config.has("time_trial_ghosts_enabled") else true
		analog_movement_enabled = global_config.analog_movement_enabled if global_config.has("analog_movement_enabled") else true
		weapon_wheel_enabled = global_config.weapon_wheel_enabled if global_config.has("weapon_wheel_enabled") else true
		extra_checkpoints = global_config.extra_checkpoints if global_config.has("extra_checkpoints") else false
		locale = global_config.locale if global_config.has("locale") else TranslationServer.get_locale()
		_set_or_default(global_config, "auto_fire_mode")
		_set_or_default(global_config, "auto_charge_enabled")
	file.close()
	TranslationServer.set_locale(locale)
	return content

func save_defaults():
	var uuid =  v4()
	player_name = "DEFAULT_USER"
	player_id = uuid
	var config_default = {
		"config_version": CONFIG_VERSION,
		"window_size" : window_size,
		"die_on_spikes" : true,
		"default_lives" : 2,
		"show_damage": false,
		"is_down_jump_enabled": true,
		"bgm": -20,
		"sfx":-20,
		"has_beat_game":false,
		"highest_rank": "?",
		"total_accumulated_playtime": 0,
		"player_name": player_name,
		"player_id": player_id,
		"is_player_new_to_game":true,
		"show_filters":show_filters,
		"pause_on_health_pickup": pause_on_health_pickup,
		"skip_boss_dialog":skip_boss_dialog,
		"midgame_cutscene_seen":midgame_cutscene_seen,
		"all_robot_cutscene_seen":all_robot_cutscene_seen,
		"lienient_timings":lienient_timings,
		"show_Bolts_on_pickup": show_Bolts_on_pickup,
		"show_score_display": show_score_display,
		"time_trial_ghosts_enabled": time_trial_ghosts_enabled,
		"auto_fire_mode": auto_fire_mode,
		"auto_charge_enabled": auto_charge_enabled,
		"analog_movement_enabled": analog_movement_enabled,
		"extra_checkpoints": extra_checkpoints,
		"weapon_wheel_enabled": weapon_wheel_enabled,
		"locale":locale,
	}
	write_to_config_file(config_default)
	global_config = config_default

func save_config():
	write_to_config_file({
		"config_version": CONFIG_VERSION,
		"window_size" : window_size,
		"die_on_spikes" : die_on_spikes,
		"default_lives" : default_lives,
		"show_damage": show_damage_values,
		"is_down_jump_enabled": is_down_jump_enabled,
		"bgm": music_volume,
		"sfx": sound_effect_volume,
		"has_beat_game":has_beat_game,
		"highest_rank": highest_rank,
		"total_accumulated_playtime": total_accumulated_playtime,
		"player_name": player_name,
		"player_id": player_id,
		"is_player_new_to_game": is_player_new_to_game,
		"show_filters":show_filters,
		"pause_on_health_pickup": pause_on_health_pickup,
		"skip_boss_dialog":skip_boss_dialog,
		"midgame_cutscene_seen":midgame_cutscene_seen,
		"all_robot_cutscene_seen":all_robot_cutscene_seen,
		"lienient_timings":lienient_timings,
		"show_Bolts_on_pickup":show_Bolts_on_pickup,
		"show_score_display": show_score_display,
		"time_trial_ghosts_enabled": time_trial_ghosts_enabled,
		"auto_fire_mode": auto_fire_mode,
		"auto_charge_enabled": auto_charge_enabled,
		"extra_checkpoints":extra_checkpoints,
		"analog_movement_enabled": analog_movement_enabled,
		"weapon_wheel_enabled": weapon_wheel_enabled,
		"locale":locale,
	})

func write_to_config_file(settings):
	var file = File.new()
	var err = file.open_encrypted_with_pass(CONFIG_FILE_LOCAL, File.WRITE, SECURITY_KEY)
	if(err == OK):
		file.store_string(JSON.print(settings,"\t"))
	else:
		printerr(err)

func write_to_file(settings):
	var file = File.new()
	var err = file.open(BUTTON_MAPPINGS_FILE, File.WRITE)
	if(err == OK):
		file.store_string(JSON.print(settings,"\t"))
	else:
		printerr(err)

func apply_volume():
	set_volume()

func load_config():
	var file = File.new()
	if(!file.file_exists(CONFIG_FILE_LOCAL)):
		save_defaults()
	else:
		load_config_from_file()
		if player_id == "":
			player_id = v4()
	file.close()

func load_buttons_file():
	var file = File.new()
	if(!file.file_exists(BUTTON_MAPPINGS_FILE)):
		save_default_buttons()
	else:
		load_bindings()
	file.close()

# Changes the window size
func set_window_size():
	OS.window_fullscreen = window_size == WINDOW_FULL_SCREEN
	if not OS.window_fullscreen:
		OS.window_size = max(window_size, 1) * get_base_size()
		center_screen()
	emit_signal("size_changed")
	save_config()

func get_base_size() -> Vector2:
	return Vector2(DEFAULT_WINDOW_WIDTH, DEFAULT_WINDOW_HEIGHT)

func center_screen() -> void:
	var screen = OS.get_screen_size()
	var window = OS.get_window_size()

	OS.set_window_position(screen*0.5 - window*0.5)

func set_volume() ->void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effects"), sound_effect_volume)
	pass

func get_playtime(is_short_form:bool = false)->String:
	var _miliseconds = fmod(total_accumulated_playtime,1)*1000
	var _seconds = fmod(total_accumulated_playtime,60)
	var minutes = fmod(total_accumulated_playtime, 60*60) /60
	var hours = fmod( fmod(total_accumulated_playtime,3600*60)/3600, 500)

	return "%02d:%02d" % [hours,minutes]

func save_default_buttons():
	var button_default = {
		"up": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_UP
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_DPAD_UP
		}],
		"right": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_RIGHT
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_DPAD_RIGHT
		}],
		"down": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_DOWN
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_DPAD_DOWN
		}],
		"left": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_LEFT
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_DPAD_LEFT
		}],
		"shoot": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_X
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_2
		}],
		"jump": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_Z
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_0
		}],
		"slide": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_C
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_1
		}],
		"left_swap": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_A
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_4
		}],
		"right_swap": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_S
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_5
		}],
		"pause": [{
				"type":"key",
				"device":0,
				"scan_code": KEY_ENTER
			},{
				"type":"joypad",
				"device":0,
				"scan_code": JOY_BUTTON_11
		}],
	}
	write_to_file(button_default)

func load_bindings():
	var file = File.new()
	file.open(BUTTON_MAPPINGS_FILE, File.READ)
	var content = file.get_as_text()
	var parse_result = JSON.parse(content)
	var global_config = {}
	if(parse_result.error == OK):
		global_config = parse_result.result
		if global_config.has("up"):
			InputMap.action_erase_events("action_up_p1")
			InputMap.action_erase_events("ui_up")
			for u in global_config.up:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_up_p1",ev)
					InputMap.action_add_event("ui_up",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_up_p1",ev)
					InputMap.action_add_event("ui_up",ev)
		if global_config.has("right"):
			InputMap.action_erase_events("action_right_p1")
			InputMap.action_erase_events("ui_right")
			for u in global_config.right:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_right_p1",ev)
					InputMap.action_add_event("ui_right",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_right_p1",ev)
					InputMap.action_add_event("ui_right",ev)
		if global_config.has("down"):
			InputMap.action_erase_events("action_down_p1")
			InputMap.action_erase_events("ui_down")
			for u in global_config.down:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_down_p1",ev)
					InputMap.action_add_event("ui_down",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_down_p1",ev)
					InputMap.action_add_event("ui_down",ev)
		if global_config.has("left"):
			InputMap.action_erase_events("action_left_p1")
			InputMap.action_erase_events("ui_left")
			for u in global_config.left:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_left_p1",ev)
					InputMap.action_add_event("ui_left",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_left_p1",ev)
					InputMap.action_add_event("ui_left",ev)
		if global_config.has("shoot"):
			InputMap.action_erase_events("action_shoot_p1")
			InputMap.action_erase_events("ui_cancel")
			for u in global_config.shoot:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_shoot_p1",ev)
					InputMap.action_add_event("ui_cancel",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_shoot_p1",ev)
					InputMap.action_add_event("ui_cancel",ev)
		if global_config.has("jump"):
			InputMap.action_erase_events("action_jump_p1")
			for u in global_config.jump:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_jump_p1",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_jump_p1",ev)
		if global_config.has("slide"):
			InputMap.action_erase_events("action_slide_p1")
			for u in global_config.slide:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_slide_p1",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_slide_p1",ev)
		if global_config.has("left_swap"):
			InputMap.action_erase_events("action_left_swap_p1")
			for u in global_config.left_swap:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_left_swap_p1",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_left_swap_p1",ev)
		if global_config.has("right_swap"):
			InputMap.action_erase_events("action_right_swap_p1")
			for u in global_config.right_swap:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_right_swap_p1",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_right_swap_p1",ev)
		if global_config.has("pause"):
			InputMap.action_erase_events("action_enter_p1")
			InputMap.action_erase_events("ui_accept")
			for u in global_config.pause:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_enter_p1",ev)
					InputMap.action_add_event("ui_accept",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_enter_p1",ev)
					InputMap.action_add_event("ui_accept",ev)
		if global_config.has("skip"):
			InputMap.action_erase_events("action_skip_cutscene")
			for u in global_config.skip:
				if u.type == "key":
					var ev =  InputEventKey.new()
					ev.scancode = u.scan_code
					InputMap.action_add_event("action_skip_cutscene",ev)
				elif u.type == "joypad":
					var ev = InputEventJoypadButton.new()
					ev.device = u.device
					ev.button_index = u.scan_code
					InputMap.action_add_event("action_skip_cutscene",ev)
	file.close()
	return content

func set(property: String, value) -> void:
	var prev_value = get(property)
	.set(property, value)
	if has_user_signal(property) and value != prev_value:
		emit_signal(property, value)

func wrap_window_size(delta: int) -> void:
	window_size = posmod(window_size + delta, _get_maximum_window_scale() + 1)
	set_window_size()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _add_settings_changed_signals() -> void:
	for setting_name in DEFAULTS:
		var default_value = DEFAULTS[setting_name]
		add_user_signal(setting_name, [ { "name": "val", "type": typeof(default_value) } ])

func _set_or_default(config: Dictionary, property: String) -> void:
	assert(property in DEFAULTS)
	set(property, config.get(property, DEFAULTS[property]))

func _set_window_size(val: int) -> void:
	window_size = int(clamp(val, 0, _get_maximum_window_scale()))

func _get_maximum_window_scale() -> int:
	var screen_size: Vector2 = OS.get_screen_size()
	var base_size: Vector2 = get_base_size()
	return int(max(min(floor(screen_size.x / base_size.x), floor(screen_size.y / base_size.y)), 1))

#-------------------------------------------------
#      Connections
#-------------------------------------------------

