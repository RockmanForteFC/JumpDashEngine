extends "../menu_control.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const NEW_GAME_MENU = "new_game_menu"
const EXISTING_GAME_MENU = "existing_game_menu"
const APP_FOLDER = "user://"

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var BUTTON_MAPPINGS_FILE = ""
onready var modal = $ModalController
onready var button_list = $Menu/button_main_list

onready var key_up = $Bindings/ButtonList/d_pad_up
onready var key_right = $Bindings/ButtonList/d_pad_right
onready var key_down = $Bindings/ButtonList/d_pad_down
onready var key_left = $Bindings/ButtonList/d_pad_left
onready var key_shoot = $Bindings/ButtonList/Shoot
onready var key_jump = $Bindings/ButtonList/Jump
onready var key_slide = $Bindings/ButtonList/Slide
onready var key_swap_left = $Bindings/ButtonList/swap_left
onready var key_swap_right = $Bindings/ButtonList/swap_right
onready var key_pause = $Bindings/ButtonList/Pause
onready var key_skip = $Bindings/ButtonList/Skip

var selected_binding = ""
var keys:Array = []

var _is_fading = true
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$emergency_restore.bbcode_text = tr("CONFIG_CONTROLLER_EMERGENCY_RESTORE")
	var prefix = ""
	BUTTON_MAPPINGS_FILE =  APP_FOLDER + prefix +  ProjectSettings.get_setting("application/config/controller_mappings") + ".cnf"
	update_bindings()
	fade_in()
	yield(self,"fade_in")
	_is_fading = false

func _input(event):
	if selected_binding != "":
		if Input.is_action_just_pressed("ui_focus_next"):
			close_modal()
			button_list.is_active = true
			apply_keys(selected_binding)
			selected_binding = ""
		elif Input.is_action_just_pressed("ui_reset"):
			pass
		elif event is InputEventKey or event is InputEventJoypadButton:
			if event.is_pressed():
				keys.append(event)
				var key_label = Label.new()
				key_label.autowrap = true
				key_label.add_font_override("font", load("res://assets/fonts/small_font.tres"))
				var text = event.as_text()
				if text.begins_with("InputEventJoypadButton"):
					text = "JP:"+ text.substr(text.find("=")+1,(text.find(",")-1 - text.find("=")+1 )-1)
				key_label.text = text
				$ModalController/Popup/VBoxContainer.add_child(key_label)
	elif Input.is_action_just_pressed("ui_cancel") and not _is_fading:
		_is_fading = true
		if PlayerValues.last_played_level == NEW_GAME_MENU:
			fade_out()
			yield(self,"fade_out")
			return get_tree().change_scene("res://scenes/menus/main_menu/main_menu.tscn")
		elif PlayerValues.last_played_level == EXISTING_GAME_MENU:
			fade_out()
			yield(self,"fade_out")
			return get_tree().change_scene("res://scenes/menus/existing_game_menu/existing_game_menu.tscn")
		else:
			fade_out()
			yield(self,"fade_out")
			return get_tree().change_scene("res://scenes/menus/Start_Screen.tscn")
	elif Input.is_action_just_pressed("ui_reset"):
		_default_up()
		_default_right()
		_default_down()
		_default_left()
		_default_shoot()
		_default_jump()
		_default_slide()
		_default_swap_left()
		_default_swap_right()
		_default_pause()
		_default_skip()
		update_bindings()
		save_bindings()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func save_bindings():
	var up_keys = _get_keys("action_up_p1")
	var right_keys = _get_keys("action_right_p1")
	var down_keys = _get_keys("action_down_p1")
	var left_keys = _get_keys("action_left_p1")
	var shoot_keys = _get_keys("action_shoot_p1")
	var jump_keys = _get_keys("action_jump_p1")
	var slide_keys = _get_keys("action_slide_p1")
	var left_swap_keys = _get_keys("action_left_swap_p1")
	var right_swap_keys = _get_keys("action_right_swap_p1")
	var pause_keys = _get_keys("action_enter_p1")
	var skip_keys = _get_keys("action_skip_cutscene")

	write_to_file({
		"up": up_keys,
		"right": right_keys,
		"down": down_keys,
		"left": left_keys,
		"shoot": shoot_keys,
		"jump":jump_keys,
		"slide": slide_keys,
		"left_swap": left_swap_keys,
		"right_swap": right_swap_keys,
		"pause": pause_keys,
		"skip": skip_keys
	})

func write_to_file(settings):
	var file = File.new()
	var err = file.open(BUTTON_MAPPINGS_FILE, File.WRITE)
	if(err == OK):
		file.store_string(JSON.print(settings,"\t"))
	else:
		printerr(err)

func update_bindings():
	var up_map = InputMap.get_action_list("action_up_p1")
	var up_keys:String = ""
	for i in range(up_map.size()):
		var key:String = up_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		up_keys += key + " "
	key_up.text = up_keys
	key_up.align =Label.ALIGN_RIGHT

	var down_map = InputMap.get_action_list("action_down_p1")
	var down_keys:String = ""
	for i in range(down_map.size()):
		var key:String = down_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		down_keys += key + " "
	key_down.text = down_keys
	key_down.align =Label.ALIGN_RIGHT

	var left_map = InputMap.get_action_list("action_left_p1")
	var left_keys:String = ""
	for i in range(left_map.size()):
		var key:String = left_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		left_keys += key + " "
	key_left.text = left_keys
	key_left.align =Label.ALIGN_RIGHT

	var right_map = InputMap.get_action_list("action_right_p1")
	var right_keys:String = ""
	for i in range(right_map.size()):
		var key:String = right_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		right_keys += key + " "
	key_right.text = right_keys
	key_right.align =Label.ALIGN_RIGHT

	var shoot_map = InputMap.get_action_list("action_shoot_p1")
	var shoot_keys:String = ""
	for i in range(shoot_map.size()):
		var key:String = shoot_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		shoot_keys += key + " "
	key_shoot.text = shoot_keys
	key_shoot.align =Label.ALIGN_RIGHT

	var jump_map = InputMap.get_action_list("action_jump_p1")
	var jump_keys:String = ""
	for i in range(jump_map.size()):
		var key:String = jump_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		jump_keys += key + " "
	key_jump.text = jump_keys
	key_jump.align =Label.ALIGN_RIGHT

	var slide_map = InputMap.get_action_list("action_slide_p1")
	var slide_keys:String = ""
	for i in range(slide_map.size()):
		var key:String = slide_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		slide_keys += key + " "
	key_slide.text = slide_keys
	key_slide.align =Label.ALIGN_RIGHT

	var swap_left_map = InputMap.get_action_list("action_left_swap_p1")
	var swap_l_keys:String = ""
	for i in range(swap_left_map.size()):
		var key:String = swap_left_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		swap_l_keys += key + " "
	key_swap_left.text = swap_l_keys
	key_swap_left.align =Label.ALIGN_RIGHT

	var swap_right_map = InputMap.get_action_list("action_right_swap_p1")
	var swap_r_keys:String = ""
	for i in range(swap_right_map.size()):
		var key:String = swap_right_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		swap_r_keys += key + " "
	key_swap_right.text = swap_r_keys
	key_swap_right.align =Label.ALIGN_RIGHT

	var pause_map = InputMap.get_action_list("action_enter_p1")
	var pause_keys:String = ""
	for i in range(pause_map.size()):
		var key:String = pause_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		pause_keys += key + " "
	key_pause.text = pause_keys
	key_pause.align =Label.ALIGN_RIGHT

	var skip_map = InputMap.get_action_list("action_skip_cutscene")
	var skip_keys:String = ""
	for i in range(skip_map.size()):
		var key:String = skip_map[i].as_text()
		if key.begins_with("InputEventJoypadButton"):
			key = "JP:"+ key.substr(key.find("=")+1,(key.find(",")-1 - key.find("=")+1 )-1)
		skip_keys += key + " "
	key_skip.text = skip_keys
	key_skip.align =Label.ALIGN_RIGHT

func apply_keys(binding:String ):
	if binding == "up":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_up_p1",key)
				InputMap.action_add_event("ui_up",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_up_p1",key)
				InputMap.action_add_event("ui_up",key)
	if binding == "right":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_right_p1",key)
				InputMap.action_add_event("ui_right",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_right_p1",key)
				InputMap.action_add_event("ui_right",key)
	if binding == "down":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_down_p1",key)
				InputMap.action_add_event("ui_down",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_down_p1",key)
				InputMap.action_add_event("ui_down",key)
	if binding == "left":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_left_p1",key)
				InputMap.action_add_event("ui_left",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_left_p1",key)
				InputMap.action_add_event("ui_left",key)
	if binding == "shoot":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_shoot_p1",key)
				InputMap.action_add_event("ui_cancel",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_shoot_p1",key)
				InputMap.action_add_event("ui_cancel",key)
	if binding == "jump":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_jump_p1",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_jump_p1",key)
	if binding == "slide":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_slide_p1",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_slide_p1",key)
	if binding == "left_swap":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_left_swap_p1",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_left_swap_p1",key)
	if binding == "right_swap":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_right_swap_p1",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_right_swap_p1",key)
	if binding == "pause":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_enter_p1",key)
				InputMap.action_add_event("ui_accept",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_enter_p1",key)
				InputMap.action_add_event("ui_accept",key)

	if binding == "skip":
		for key in keys:
			if key is InputEventKey:
				InputMap.action_add_event("action_skip_cutscene",key)

			if key is InputEventJoypadButton:
				InputMap.action_add_event("action_skip_cutscene",key)

	for child in $ModalController/Popup/VBoxContainer.get_children():
		 $ModalController/Popup/VBoxContainer.remove_child(child)
	save_bindings()
	keys = []
	selected_binding = ""
	update_bindings()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _default_up():
	InputMap.action_erase_events("action_up_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_UP
	InputMap.action_add_event("action_up_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_DPAD_UP
	InputMap.action_add_event("action_up_p1",ev2)

func _default_right():
	InputMap.action_erase_events("action_right_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_RIGHT
	InputMap.action_add_event("action_right_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_DPAD_RIGHT
	InputMap.action_add_event("action_right_p1",ev2)

func _default_down():
	InputMap.action_erase_events("action_down_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_DOWN
	InputMap.action_add_event("action_down_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_DPAD_DOWN
	InputMap.action_add_event("action_down_p1",ev2)

func _default_left():
	InputMap.action_erase_events("action_left_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_LEFT
	InputMap.action_add_event("action_left_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_DPAD_LEFT
	InputMap.action_add_event("action_left_p1",ev2)

func _default_shoot():
	InputMap.action_erase_events("action_shoot_p1")
	InputMap.action_erase_events("ui_cancel")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_X
	InputMap.action_add_event("action_shoot_p1",ev)
	InputMap.action_add_event("ui_cancel",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_2
	InputMap.action_add_event("action_shoot_p1",ev2)
	InputMap.action_add_event("ui_cancel",ev2)

func _default_jump():
	InputMap.action_erase_events("action_jump_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_Z
	InputMap.action_add_event("action_jump_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_0
	InputMap.action_add_event("action_jump_p1",ev2)

func _default_slide():
	InputMap.action_erase_events("action_slide_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_C
	InputMap.action_add_event("action_slide_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_1
	InputMap.action_add_event("action_slide_p1",ev2)

func _default_swap_left():
	InputMap.action_erase_events("action_left_swap_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_A
	InputMap.action_add_event("action_left_swap_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_4
	InputMap.action_add_event("action_left_swap_p1",ev2)

func _default_swap_right():
	InputMap.action_erase_events("action_right_swap_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_S
	InputMap.action_add_event("action_right_swap_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_5
	InputMap.action_add_event("action_right_swap_p1",ev2)

func _default_pause():
	InputMap.action_erase_events("action_enter_p1")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_ENTER
	InputMap.action_add_event("ui_accept",ev)
	InputMap.action_add_event("action_enter_p1",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_11
	InputMap.action_add_event("action_enter_p1",ev2)
	InputMap.action_add_event("ui_accept",ev2)

func _default_skip():
	InputMap.action_erase_events("action_skip_cutscene")
	var ev =  InputEventKey.new()
	ev.scancode = KEY_ESCAPE
	InputMap.action_add_event("action_skip_cutscene",ev)

	var ev2 = InputEventJoypadButton.new()
	ev2.device = 0
	ev2.button_index = JOY_BUTTON_10

	InputMap.action_add_event("action_skip_cutscene",ev2)

func _get_keys(mapping:String)->Array:
	var keys:Array
	var map = InputMap.get_action_list(mapping)
	for i in range(map.size()):
		var array_item = {}
		if map[i] is InputEventKey:
			array_item["type"] = "key"
			array_item["device"] = 0
			array_item["scan_code"] =  map[i].scancode
		elif map[i] is InputEventJoypadButton:
			array_item["type"] = "joypad"
			array_item["device"] = 0
			array_item["scan_code"] =  map[i].button_index
		keys.append(array_item)
	return keys

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_GameStart_menu_item_selected(selected_menu_option):
	if "d_pad_up" in selected_menu_option:
		bring_up_modal()
		selected_binding = "up"
		InputMap.action_erase_events("action_up_p1")
		button_list.is_active = false
	elif "d_pad_right" in selected_menu_option:
		bring_up_modal()
		selected_binding = "right"
		InputMap.action_erase_events("action_right_p1")
		button_list.is_active = false
	elif "d_pad_down" in selected_menu_option:
		bring_up_modal()
		selected_binding = "down"
		InputMap.action_erase_events("action_down_p1")
		button_list.is_active = false
	elif "d_pad_left" in selected_menu_option:
		bring_up_modal()
		selected_binding = "left"
		InputMap.action_erase_events("action_left_p1")
		button_list.is_active = false
	elif "Shoot" in selected_menu_option:
		bring_up_modal()
		selected_binding = "shoot"
		InputMap.action_erase_events("action_shoot_p1")
		InputMap.action_erase_events("ui_cancel")
		button_list.is_active = false
	elif "Jump" in selected_menu_option:
		bring_up_modal()
		selected_binding = "jump"
		InputMap.action_erase_events("action_jump_p1")
		button_list.is_active = false
	elif "Slide" in selected_menu_option:
		bring_up_modal()
		selected_binding = "slide"
		InputMap.action_erase_events("action_slide_p1")
		button_list.is_active = false
	elif "swap_left" in selected_menu_option:
		bring_up_modal()
		selected_binding = "left_swap"
		InputMap.action_erase_events("action_left_swap_p1")
		button_list.is_active = false
	elif "swap_right" in selected_menu_option:
		bring_up_modal()
		selected_binding = "right_swap"
		InputMap.action_erase_events("action_right_swap_p1")
		button_list.is_active = false
	elif "Pause" in selected_menu_option:
		bring_up_modal()
		selected_binding = "pause"
		InputMap.action_erase_events("action_enter_p1")
		InputMap.action_erase_events("ui_accept")
		button_list.is_active = false
	elif "Skip" in selected_menu_option:
		bring_up_modal()
		selected_binding = "skip"
		InputMap.action_erase_events("action_skip_cutscene")
		button_list.is_active = false
	elif "restore defaults" in selected_menu_option:
		_default_up()
		_default_right()
		_default_down()
		_default_left()
		_default_shoot()
		_default_jump()
		_default_slide()
		_default_swap_left()
		_default_swap_right()
		_default_pause()
		_default_skip()

		update_bindings()
	save_bindings()

func bring_up_modal():
	modal.show()
	$emergency_restore.hide()

func close_modal():
	modal.hide()
	$emergency_restore.show()
