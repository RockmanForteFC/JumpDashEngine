extends "../menu_control.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const GREEN = Color("80d010")
const RED = Color("d82800")
const NEW_GAME_MENU = "new_game_menu"
const EXISTING_GAME_MENU = "existing_game_menu"
const VIRUS_GAME_MENU = "virus_game_menu"
const VOLUME_STEP_SIZE:int = 5
const SELECTED_TAB:String = "f0b838"
const NON_SELECTED_TAB:String = "505e00"
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var game_container = $ContentArea/Game_Container
onready var accessibility_container = $ContentArea/Accessibility_Container

onready var screen_size = $ContentArea/Game_Container/VBoxContainer/screen_size/setting_result
onready var music_volume = $ContentArea/Game_Container/VBoxContainer/BGM_volume/music_slider
onready var sfx_volume = $ContentArea/Game_Container/VBoxContainer/SFX_volume/sfx_slider
onready var down_jump_slide = $ContentArea/Accessibility_Container/VBoxContainer/down_slide/setting_result
onready var die_on_spikes = $ContentArea/Accessibility_Container/VBoxContainer/die_on_spikes/setting_result
onready var default_lives = $ContentArea/Accessibility_Container/VBoxContainer/default_lives/setting_result
onready var show_damage = $ContentArea/Accessibility_Container/VBoxContainer/show_damage_values/setting_result
onready var lienient_timings = $ContentArea/Accessibility_Container/VBoxContainer/lenient_timings/setting_result
onready var show_bolts_on_pickup = $ContentArea/Accessibility_Container/VBoxContainer/show_bolts_on_pickup/setting_result
onready var auto_fire_mode = $ContentArea/Accessibility_Container/VBoxContainer/auto_fire_mode/setting_result
onready var auto_charge_enabled = $ContentArea/Accessibility_Container/VBoxContainer/auto_charge_enabled/setting_result
onready var analog_movement_enabled = $ContentArea/Accessibility_Container/VBoxContainer/analog_movement_enabled/setting_result
onready var weapon_wheel = $ContentArea/Accessibility_Container/VBoxContainer/weapon_wheel/setting_result

onready var modal_controller = $ModalController

onready var tab_game = $ContentArea/Tabs/HBoxContainer/tab_game/setting_name
onready var tab_accessibility = $ContentArea/Tabs/HBoxContainer/tab_accessibility/setting_name

var can_change_screen:bool = true
var is_modal_open:bool = false
var _is_fading = true
var is_game_selected:bool = true
var is_accessibility_selected:bool = false
var confirmation_position:int = 1
var selected_clear_option:int = 0

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Label/AnimationPlayer.play("flash")

	populate_menu()
	is_game_selected = true
	is_accessibility_selected = false

	tab_game.modulate = Color(SELECTED_TAB)
	tab_accessibility.modulate = Color(NON_SELECTED_TAB)

	game_container.show()
	accessibility_container.hide()

	Config.connect("auto_fire_mode", self, "_on_auto_fire_mode_changed")
	Config.connect("auto_charge_enabled", self, "_on_auto_charge_enabled_changed")
	$ContentArea/Game_Container/VBoxContainer/screen_size.grab_focus()
	for node in $ContentArea/Game_Container/VBoxContainer.get_children():
		if node is TextureButton:
			node.connect("pressed", self, "_on_pressed",[node])
			node.connect("focus_exited", self, "_click_sound")
	for node in $ContentArea/Accessibility_Container/VBoxContainer.get_children():
		if node is TextureButton:
			node.connect("pressed", self, "_on_pressed",[node])
			node.connect("focus_exited", self, "_click_sound")

	fade_in()
	yield(self,"fade_in")
	_is_fading = false

func _physics_process(delta):
	if !is_modal_open:
		var focused_node = get_focus_owner()
		if focused_node != null and focused_node.name == "BGM_volume":
			if Input.is_action_just_pressed("ui_left"):
				music_volume.value = clamp(music_volume.value - VOLUME_STEP_SIZE, -80, 0)
				Config.music_volume = music_volume.value
				Config.save_config()
			elif Input.is_action_just_pressed("ui_right"):
				music_volume.value = clamp(music_volume.value + VOLUME_STEP_SIZE, -80, 0)
				Config.music_volume = music_volume.value
				Config.save_config()
			_set_bgm()
		elif focused_node != null and focused_node.name == "SFX_volume":
			if Input.is_action_just_pressed("ui_left"):
				sfx_volume.value = clamp(sfx_volume.value - VOLUME_STEP_SIZE, -80, 0)
				_set_sfx()
			elif Input.is_action_just_pressed("ui_right"):
				sfx_volume.value = clamp(sfx_volume.value + VOLUME_STEP_SIZE, -80, 0)
				_set_sfx()
		if Input.is_action_just_pressed("ui_cancel") and not _is_fading:
			_is_fading = true
			fade_out()
			yield(self,"fade_out")
			if PlayerValues.last_played_level == NEW_GAME_MENU:
				return get_tree().change_scene("res://scenes/menus/main_menu/main_menu.tscn")
			elif PlayerValues.last_played_level == EXISTING_GAME_MENU:
				return get_tree().change_scene("res://scenes/menus/existing_game_menu/existing_game_menu.tscn")
			elif PlayerValues.last_played_level == VIRUS_GAME_MENU:
				return get_tree().change_scene("res://scenes/menus/virus_game_menu/virus_game_menu.tscn")
			else:
				return get_tree().change_scene("res://scenes/menus/Start_Screen.tscn")
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func populate_menu():
	if Config.window_size != Config.WINDOW_FULL_SCREEN:
		screen_size.text = str(Config.window_size) + "X"
	else:
		screen_size.text = "FULL SCREEN"

	_get_lives()

	show_damage.text = "ON" if Config.show_damage_values else "OFF"
	show_damage.modulate = GREEN if Config.show_damage_values else RED

	down_jump_slide.text = "ON" if Config.is_down_jump_enabled else "OFF"
	down_jump_slide.modulate = GREEN if Config.is_down_jump_enabled else RED

	lienient_timings.text = "DELAYED" if Config.lienient_timings else "NORMAL"
	lienient_timings.modulate = GREEN if !Config.lienient_timings else RED

	show_bolts_on_pickup.text = "ON" if Config.show_Bolts_on_pickup else "OFF"
	show_bolts_on_pickup.modulate = GREEN if Config.show_Bolts_on_pickup else RED

	analog_movement_enabled.text = "ON" if Config.analog_movement_enabled else "OFF"
	analog_movement_enabled.modulate = GREEN if Config.analog_movement_enabled else RED

	weapon_wheel.text = "ON" if Config.weapon_wheel_enabled else "OFF"
	weapon_wheel.modulate = GREEN if Config.weapon_wheel_enabled else RED

	music_volume.value = Config.music_volume
	sfx_volume.value = Config.sound_effect_volume

	_update_auto_fire_mode_setting()
	_update_auto_charge_enabled_setting()

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _click_sound():
	$Audio/click.play()

func _set_sfx():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effects"), sfx_volume.value)
	Config.sound_effect_volume = sfx_volume.value
	$Audio/sfx_test.play()
	Config.save_config()

func _set_bgm():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume.value)
	Config.music_volume = music_volume.value

func _get_lives():
	if Config.default_lives == 2:
		default_lives.text = str(Config.default_lives)
		default_lives.modulate = Color("ffffff")
		$ContentArea/Accessibility_Container/VBoxContainer/default_lives/default_label.show()
	elif Config.default_lives == -100:
		default_lives.text = "Infinite Lives"
		default_lives.modulate = RED
		$ContentArea/Accessibility_Container/VBoxContainer/default_lives/default_label.hide()
	else:
		PlayerValues.lives = 0
		default_lives.text = str(Config.default_lives)
		default_lives.modulate = Color("ffffff")
		$ContentArea/Accessibility_Container/VBoxContainer/default_lives/default_label.hide()

func _update_auto_fire_mode_setting() -> void:
	var mode: int = Config.auto_fire_mode
	var option_text = Config.AUTO_FIRE_MODE.keys()[mode].to_upper()
	auto_fire_mode.text = option_text
	auto_fire_mode.modulate = GREEN if mode != Config.AUTO_FIRE_MODE.off else RED

func _update_auto_charge_enabled_setting() -> void:
	var enabled: bool = Config.auto_charge_enabled
	auto_charge_enabled.text = "ON" if enabled else "OFF"
	auto_charge_enabled.modulate = GREEN if enabled else RED

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_pressed(node:TextureButton):
	if !is_modal_open:
		if !node.name == "BGM_volume" and !node.name == "SFX_volume" and !node.name == "screen_size":
			$Audio/OK.play()
		if node.name == "account_name":
			is_modal_open = true
			modal_controller.show()
			$ModalController/Popup/username.grab_focus()
		elif node.name == "clear_cd_data":
			is_modal_open = true
			$ConfirmModal/Popup/Control/AnimatedSprite.global_position = $ConfirmModal/Popup/Control/no/Position2D2.global_position
			confirmation_position = 1
			$ConfirmModal/Popup/clear_prompt.text = tr("CONFIG_CLEAR_CDS")
			$ConfirmModal.show()
			$ConfirmModal/Popup/Control.grab_focus()
			selected_clear_option = 0
		elif node.name == "clear_bestiary_data":
			is_modal_open = true
			$ConfirmModal/Popup/Control/AnimatedSprite.global_position = $ConfirmModal/Popup/Control/no/Position2D2.global_position
			confirmation_position = 1
			$ConfirmModal/Popup/clear_prompt.text = tr("CONFIG_CLEAR_BESTIARY")
			$ConfirmModal.show()
			$ConfirmModal/Popup/Control.grab_focus()
			selected_clear_option = 1
		elif node.name == "clear_trophy_data":
			is_modal_open = true
			$ConfirmModal/Popup/Control/AnimatedSprite.global_position = $ConfirmModal/Popup/Control/no/Position2D2.global_position
			confirmation_position = 1
			$ConfirmModal/Popup/clear_prompt.text = tr("CONFIG_CLEAR_TROPHIES")
			$ConfirmModal.show()
			$ConfirmModal/Popup/Control.grab_focus()
			selected_clear_option = 2

		elif node.name == "screen_size" and can_change_screen:
			can_change_screen = false
			$Audio/OK.play()
			$screen_change_timer.start()
			Config.wrap_window_size(1)
			if Config.window_size != Config.WINDOW_FULL_SCREEN:
				screen_size.text = str(Config.window_size) + "X"
			else:
				screen_size.text = "FULL SCREEN"
		elif node.name == "default_lives":
			if Config.default_lives == 9:
				Config.default_lives = -100
			elif Config.default_lives == -100:
				Config.default_lives = 0
			else:
				Config.default_lives += 1

			_get_lives()

		elif node.name == "down_slide":
			Config.is_down_jump_enabled = not Config.is_down_jump_enabled
			down_jump_slide.text = "ON" if Config.is_down_jump_enabled else "OFF"
			down_jump_slide.modulate = GREEN if Config.is_down_jump_enabled else RED
		elif node.name == "Language":
			if tr("CONFIG_SELECTED_LANGUAGE") == "English":
				Config.locale = "es"
				yield($Audio/OK,"finished")
				TranslationServer.set_locale(Config.locale)
				get_tree().reload_current_scene()
			elif tr("CONFIG_SELECTED_LANGUAGE") == "Español":
				Config.locale = "ja"
				yield($Audio/OK,"finished")
				TranslationServer.set_locale(Config.locale)
				get_tree().reload_current_scene()
			elif tr("CONFIG_SELECTED_LANGUAGE") == "日本語":
				Config.locale = "pt_BR"
				yield($Audio/OK,"finished")
				TranslationServer.set_locale(Config.locale)
				get_tree().reload_current_scene()
			elif tr("CONFIG_SELECTED_LANGUAGE") == "(BR) Português":
				Config.locale = "en"
				yield($Audio/OK,"finished")
				TranslationServer.set_locale(Config.locale)
				get_tree().reload_current_scene()
		elif node.name == "lenient_timings":
			Config.lienient_timings = not Config.lienient_timings
			lienient_timings.text = "DELAYED" if Config.lienient_timings else "NORMAL"
			lienient_timings.modulate = GREEN if !Config.lienient_timings else RED
		elif node.name == "show_bolts_on_pickup":
			Config.show_Bolts_on_pickup = not Config.show_Bolts_on_pickup
			show_bolts_on_pickup.text = "ON" if Config.show_Bolts_on_pickup else "OFF"
			show_bolts_on_pickup.modulate = GREEN if Config.show_Bolts_on_pickup else RED
		elif node.name == "die_on_spikes":
			Config.die_on_spikes = not Config.die_on_spikes
			die_on_spikes.text = "ON" if Config.die_on_spikes else "OFF"
			die_on_spikes.modulate = GREEN if Config.die_on_spikes else RED
		elif node.name == "show_damage_values":
			Config.show_damage_values = not Config.show_damage_values
			show_damage.text = "ON" if Config.show_damage_values else "OFF"
			show_damage.modulate = GREEN if Config.show_damage_values else RED
		elif node.name == "analog_movement_enabled":
			Config.analog_movement_enabled = not Config.analog_movement_enabled
			analog_movement_enabled.text = "ON" if Config.analog_movement_enabled else "OFF"
			analog_movement_enabled.modulate = GREEN if Config.analog_movement_enabled else RED
		elif node.name == "weapon_wheel":
			Config.weapon_wheel_enabled = not Config.weapon_wheel_enabled
			weapon_wheel.text = "ON" if Config.weapon_wheel_enabled else "OFF"
			weapon_wheel.modulate = GREEN if Config.weapon_wheel_enabled else RED
		elif node.name == "auto_fire_mode":
			Config.set(node.name, posmod(Config.auto_fire_mode + 1, Config.AUTO_FIRE_MODE.size()))
			_update_auto_fire_mode_setting()
		elif node.name == "auto_charge_enabled":
			Config.set(node.name, not Config.auto_charge_enabled)
			_update_auto_charge_enabled_setting()
		Config.save_config()

func _on_music_slider_drag_ended(value_changed):
	$ContentArea/Game_Container/VBoxContainer/BGM_volume.grab_focus()
	_set_bgm()
	Config.save_config()

func _on_sfx_slider_drag_ended(value_changed):
	$ContentArea/Game_Container/VBoxContainer/SFX_volume.grab_focus()
	_set_sfx()

func _on_screen_change_timer_timeout():
	can_change_screen = true

func _on_auto_fire_mode_changed(auto_fire_mode: int) -> void:
	if auto_fire_mode != Config.AUTO_FIRE_MODE.off and not Config.auto_charge_enabled:
		Config.set("auto_charge_enabled", true)
		_update_auto_charge_enabled_setting()

func _on_auto_charge_enabled_changed(auto_charge_enabled: bool) -> void:
	if not auto_charge_enabled and Config.auto_fire_mode != Config.AUTO_FIRE_MODE.off:
		Config.set("auto_fire_mode", Config.AUTO_FIRE_MODE.off)
		_update_auto_fire_mode_setting()


func _on_tab_game_pressed():
	is_game_selected = true
	is_accessibility_selected = false

	tab_game.modulate = Color(SELECTED_TAB)
	tab_accessibility.modulate = Color(NON_SELECTED_TAB)

	game_container.show()
	accessibility_container.hide()
	$ContentArea/Game_Container/VBoxContainer/screen_size.grab_focus()

func _on_tab_accessibility_pressed():
	is_game_selected = false
	is_accessibility_selected = true

	tab_game.modulate = Color(NON_SELECTED_TAB)
	tab_accessibility.modulate = Color(SELECTED_TAB)

	game_container.hide()
	accessibility_container.show()
	$ContentArea/Accessibility_Container/VBoxContainer/default_lives.grab_focus()
