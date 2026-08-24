extends Control

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const TOAST = preload("res://scenes/menus/toast_message/toast_message.tscn")

const WEAPONS_LEFT = "Column_Left"
const WEAPONS_RIGHT = "Column_Right"
const TANKS = "Tanks_Container"
const FUNCTION_BUTTONS = "Function_Buttons"
const W_TANK_WEAPONS_LEFT = "W_Tank_Column_Left"
const W_TANK_WEAPONS_RIGHT = "W_Tank_Column_Right"

const E_TANK_POS = 0
const W_TANK_POS = 1
const M_TANK_POS = 2
const DEFAULT = 0
const NOTHING = -1

const PAGE_ONE = 1
const PAGE_TWO = 2
const TANK_FILL_DELAY:float = 0.05
const WAIT_TIME:float = 0.1
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal game_paused()
signal game_resumed()
#-------------------------------------------------
#      Properties
#-------------------------------------------------
var can_pause:bool = false
var current_page:int = 1
var can_user_control:bool = false
var is_paused:bool = false
var highlighted_area:String = WEAPONS_LEFT
var highlighted_index:int = 0
var w_tank_highlighted_index:int = 0
var has_infinite_lives:bool = false
var can_exit_stage:bool = true

onready var weapon0 = $Menu_Left/Weapons_Container/Column_Left/Slot_1/Mega_Buster
onready var weapon1 = $Menu_Left/Weapons_Container/Column_Left/Slot_2/Incinerate
onready var weapon2 = $Menu_Left/Weapons_Container/Column_Left/Slot_3/Tremor_Pulse
onready var weapon3 = $Menu_Left/Weapons_Container/Column_Left/Slot_4/Maelstrom
onready var weapon4 = $Menu_Left/Weapons_Container/Column_Left/Slot_5/Silhouette_Kunai
onready var weapon10 = $Menu_Left/Weapons_Container/Column_Left/Slot_6/Utility_Slot_A

onready var weapon5 = $Menu_Left/Weapons_Container/Column_Right/Slot_7/Beam
onready var weapon6 = $Menu_Left/Weapons_Container/Column_Right/Slot_8/Brawler
onready var weapon7 = $Menu_Left/Weapons_Container/Column_Right/Slot_9/Arctic
onready var weapon8 = $Menu_Left/Weapons_Container/Column_Right/Slot_10/Detonate
onready var weapon9 = $Menu_Left/Weapons_Container/Column_Right/Slot_11/MsWilyCollectables
onready var weapon11 = $Menu_Left/Weapons_Container/Column_Right/Slot_12/Utility_Slot_B

onready var e_tanks = $Menu_Left/Tanks_Container/E_Tank/E_Tank_Count
onready var w_tanks = $Menu_Left/Tanks_Container/W_Tank/W_Tank_Count
onready var m_tanks = $Menu_Left/Tanks_Container/M_Tank/M_Tank_Count
onready var bolts = $Menu_Left/Bolts_Container/Bolts/Bolt_Count
onready var lives = $Menu_Left/Lives_Container/Lives/Lives_Count

onready var knockback = $Menu_Left/Rogue_Items/Item1/Knock_Count
onready var damage = $Menu_Left/Rogue_Items/Item2/Dmg_Count

onready var tank_selection = $Menu_Left/Tanks_Container/Tank_Selection

onready var menu_tick_sound = $Audio/Focus_Change

onready var function_button_description_box = $Menu_Right/Description_Box/Highlighted_Item_Description

onready var weapons_upgrade_unlock_message = $Menu_Right/Weapon_Upgrade_Area/Weapons_Upgrade_Unlock_Message
onready var upgraded_weapon_icon = $Menu_Right/Weapon_Upgrade_Area/Upgraded_Weapon/Icon
onready var upgrade_weapon_area_title = $Menu_Right/Weapon_Upgrade_Area/Upgrade_Weapon_Area_Title


onready var exit_item = $Menu_Right/Function_Buttons/Stage_Exit/Icon
onready var slide_item = $Menu_Right/Collected_Powerups/GridContainer/Slide_Powerup/Icon
onready var charge_item = $Menu_Right/Collected_Powerups/GridContainer/Charge_Powerup/Icon
onready var super_charge_item = $Menu_Right/Collected_Powerups/GridContainer/Super_Charge_Powerup/Icon
onready var shock_absorber_item = $Menu_Right/Collected_Powerups/GridContainer/Shock_Absorber/Icon
onready var bolt_attractor_item = $Menu_Right/Collected_Powerups/GridContainer/Bolt_Attractor/Icon
onready var weapon_book_item = $Menu_Right/Collected_Powerups/GridContainer/Weapon_Book/Icon
onready var energy_balancer_item = $Menu_Right/Collected_Powerups/GridContainer/Energy_Balancer/Icon
onready var energy_balancer_neo_item = $Menu_Right/Collected_Powerups/GridContainer/Energy_Balancer_Neo/Icon
onready var ability_slot_a_item = $Menu_Right/Collected_Powerups/GridContainer/Ability_Slot_A/Icon
onready var ability_slot_b_item = $Menu_Right/Collected_Powerups/GridContainer/Ability_Slot_B/Icon
onready var music_upgrade_item = $Menu_Right/Collected_Powerups/GridContainer/Music_Upgrade/Icon
onready var cd_locator_item = $Menu_Right/Collected_Powerups/GridContainer/cd_locator/Icon
onready var cd_multiplication_label = $Menu_Right/Collected_Powerups/cd_x
onready var cd_count_label = $Menu_Right/Collected_Powerups/cd_count
onready var w_tank_sprite = $Menu_Left/Tanks_Container/W_Tank_Sprite

var weapons:Array
var left_side_weapons:Array
var right_side_weapons:Array
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	yield(get_tree().create_timer(1.0),"timeout")
	if Config.default_lives == -100:
		has_infinite_lives = true
	instantiate()

func _process(delta):
	if not can_user_control and Input.is_action_just_pressed("action_enter_p1") and Physics.is_in_pausible_state:
		if not get_tree().paused and not Physics.is_game_paused:
			open_menu()

	elif can_user_control:
		#page_swaps
		if Input.is_action_just_pressed("action_right_swap_p1") and current_page == PAGE_ONE:
			can_user_control = false
			current_page = PAGE_TWO
			$AnimationPlayer.play("Menu_1_to_Menu_2")
		if Input.is_action_just_pressed("action_left_swap_p1") and current_page == PAGE_TWO:
			can_user_control = false
			current_page = PAGE_ONE
			$AnimationPlayer.play("Menu_2_to_Menu_1")

		#weapon Select
		if current_page == PAGE_ONE :
			if highlighted_area == WEAPONS_LEFT:
				if Input.is_action_just_pressed("ui_down"):
					menu_tick_sound.play()
					while true:
						highlighted_index += 1
						if highlighted_index > left_side_weapons.size() -1:
							highlighted_area = TANKS
							_change_focus([], NOTHING)
							highlighted_index = E_TANK_POS
							tank_selection.show()
							break
						if left_side_weapons[highlighted_index].weapon != null:
							_change_focus(left_side_weapons, highlighted_index)
							break
				if Input.is_action_just_pressed("ui_up"):
					menu_tick_sound.play()
					while true:
						highlighted_index -= 1
						if highlighted_index < 0:
							highlighted_area = TANKS
							_change_focus([], NOTHING)
							highlighted_index = E_TANK_POS
							tank_selection.show()
							break
						if left_side_weapons[highlighted_index].weapon != null:
							_change_focus(left_side_weapons, highlighted_index)
							break
				if Input.is_action_just_pressed("ui_right"):
					if right_side_weapons[highlighted_index].weapon != null:
						highlighted_area = WEAPONS_RIGHT
						menu_tick_sound.play()
						_change_focus(right_side_weapons,highlighted_index)
					else:
						#loop through all the right side and select the first in the list.
						for i in right_side_weapons.size()-1:
							if right_side_weapons[i].weapon != null:
								_change_focus(right_side_weapons, i)
								highlighted_index = i
								highlighted_area = WEAPONS_RIGHT
								menu_tick_sound.play()
								break
				if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
					close_menu()
			elif highlighted_area == WEAPONS_RIGHT:
				if Input.is_action_just_pressed("ui_down"):
					menu_tick_sound.play()
					while true:
						highlighted_index += 1
						if highlighted_index > right_side_weapons.size() -1:
							highlighted_area = TANKS
							_change_focus([], NOTHING)
							highlighted_index = E_TANK_POS
							tank_selection.show()
							break
						if right_side_weapons[highlighted_index].weapon != null:
							_change_focus(right_side_weapons, highlighted_index)
							break
				if Input.is_action_just_pressed("ui_up"):
					menu_tick_sound.play()
					while true:
						highlighted_index -= 1
						if highlighted_index < 0:
							highlighted_area = TANKS
							_change_focus([], NOTHING)
							highlighted_index = E_TANK_POS
							tank_selection.show()
							break
						if right_side_weapons[highlighted_index].weapon != null:
							_change_focus(right_side_weapons, highlighted_index)
							break
				if Input.is_action_just_pressed("ui_left"):
					if left_side_weapons[highlighted_index].weapon != null:
						highlighted_area = WEAPONS_LEFT
						menu_tick_sound.play()
						_change_focus(left_side_weapons,highlighted_index)
					else:
						#loop through all the right side and select the first in the list.
						for i in left_side_weapons.size()-1:
							if left_side_weapons[i].weapon != null:
								_change_focus(left_side_weapons, i)
								highlighted_index = i
								highlighted_area = WEAPONS_LEFT
								menu_tick_sound.play()
								break
				if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
					close_menu()
			elif highlighted_area == TANKS:
				if not tank_selection.playing:
					tank_selection.play("default")
				if highlighted_index == E_TANK_POS:
					tank_selection.global_position = $Menu_Left/Tanks_Container/E_Tank/E_Tank_Position.global_position
				elif highlighted_index == W_TANK_POS:
					tank_selection.global_position = $Menu_Left/Tanks_Container/W_Tank/W_Tank_Position.global_position
				elif highlighted_index == M_TANK_POS:
					tank_selection.global_position = $Menu_Left/Tanks_Container/M_Tank/M_Tank_Position.global_position
				if Input.is_action_just_pressed("ui_down"):
					menu_tick_sound.play()
					highlighted_area = WEAPONS_LEFT
					highlighted_index = DEFAULT
					_change_focus(left_side_weapons,highlighted_index)
					tank_selection.stop()
					tank_selection.hide()
				if Input.is_action_just_pressed("ui_up"):
					menu_tick_sound.play()
					highlighted_area = WEAPONS_LEFT
					highlighted_index = left_side_weapons.size()
					for i in left_side_weapons.size():
						if left_side_weapons[highlighted_index-1].weapon != null:
							_change_focus(left_side_weapons, highlighted_index-1)
							highlighted_index -=1
							break
						highlighted_index -= 1
					tank_selection.stop()
					tank_selection.hide()
				if Input.is_action_just_pressed("ui_right"):
					var previous_index = highlighted_index
					highlighted_index = clamp(highlighted_index + 1, 0, 2)
					if previous_index != highlighted_index:
						menu_tick_sound.play()
				if Input.is_action_just_pressed("ui_left"):
					var previous_index = highlighted_index
					highlighted_index = clamp(highlighted_index - 1, 0, 2)
					if previous_index != highlighted_index:
						menu_tick_sound.play()
				if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
					if highlighted_index == E_TANK_POS:
						_use_e_tank()
					elif highlighted_index == W_TANK_POS:
						_go_into_w_tank_mode()
					elif highlighted_index == M_TANK_POS:
						_use_m_tank()
			if highlighted_area == W_TANK_WEAPONS_LEFT:
				if Input.is_action_just_pressed("ui_down"):
					var original_index = w_tank_highlighted_index
					while true:
						w_tank_highlighted_index += 1
						if w_tank_highlighted_index > left_side_weapons.size() -1:
								w_tank_highlighted_index = 0
						if left_side_weapons[w_tank_highlighted_index].weapon != null:
							if w_tank_highlighted_index > left_side_weapons.size() -1:
								w_tank_highlighted_index = 0
							menu_tick_sound.play()
							var start_pos = Vector2(left_side_weapons[w_tank_highlighted_index].rect_global_position.x,left_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
							w_tank_sprite.global_position = start_pos
							break
						if w_tank_highlighted_index == left_side_weapons.size() -1:
							w_tank_highlighted_index = original_index
							break
				if Input.is_action_just_pressed("ui_up"):
					var original_index = w_tank_highlighted_index
					while true:
						w_tank_highlighted_index -= 1
						if left_side_weapons[w_tank_highlighted_index].weapon != null:
							if w_tank_highlighted_index < 0:
								w_tank_highlighted_index = 5
							menu_tick_sound.play()
							var start_pos = Vector2(left_side_weapons[w_tank_highlighted_index].rect_global_position.x,left_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
							w_tank_sprite.global_position = start_pos
							break
						# skip mega buster
						if w_tank_highlighted_index == 1:
							w_tank_highlighted_index = original_index
							break
				if Input.is_action_just_pressed("ui_right"):
					if right_side_weapons[w_tank_highlighted_index].weapon != null:
						highlighted_area = W_TANK_WEAPONS_RIGHT
						menu_tick_sound.play()
						var start_pos = Vector2(right_side_weapons[w_tank_highlighted_index].rect_global_position.x,right_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
						w_tank_sprite.global_position = start_pos
					else:
						#loop through all the right side and select the first in the list.
						for i in right_side_weapons.size()-1:
							if right_side_weapons[i].weapon != null:
								w_tank_highlighted_index = i
								var start_pos = Vector2(right_side_weapons[w_tank_highlighted_index].rect_global_position.x,right_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
								w_tank_sprite.global_position = start_pos
								highlighted_area = W_TANK_WEAPONS_RIGHT
								menu_tick_sound.play()
								break
				if Input.is_action_just_pressed("action_shoot_p1"):
					$Audio/Page_Swap.play()
					highlighted_area = TANKS
					w_tank_highlighted_index = 0
					w_tank_sprite.hide()
					w_tank_sprite.stop()
				if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
					_use_w_tank(left_side_weapons,w_tank_highlighted_index)
			if highlighted_area == W_TANK_WEAPONS_RIGHT:
				if Input.is_action_just_pressed("ui_down"):
					var original_index = w_tank_highlighted_index
					while true:
						w_tank_highlighted_index += 1
						if w_tank_highlighted_index > right_side_weapons.size() -1:
								w_tank_highlighted_index = 0
						if right_side_weapons[w_tank_highlighted_index].weapon != null:
							if w_tank_highlighted_index > right_side_weapons.size() -1:
								w_tank_highlighted_index = 0
							menu_tick_sound.play()
							var start_pos = Vector2(right_side_weapons[w_tank_highlighted_index].rect_global_position.x,right_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
							w_tank_sprite.global_position = start_pos
							break
						if w_tank_highlighted_index == right_side_weapons.size()-1:
							w_tank_highlighted_index = original_index
							break
				if Input.is_action_just_pressed("ui_up"):
					var original_index = w_tank_highlighted_index
					while true:
						w_tank_highlighted_index -= 1
						if right_side_weapons[w_tank_highlighted_index].weapon != null:
							if w_tank_highlighted_index < 0:
								w_tank_highlighted_index = 5
							menu_tick_sound.play()
							var start_pos = Vector2(right_side_weapons[w_tank_highlighted_index].rect_global_position.x,right_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
							w_tank_sprite.global_position = start_pos
							break
						if w_tank_highlighted_index == 0:
							w_tank_highlighted_index = original_index
							break
				if Input.is_action_just_pressed("ui_left"):
					if left_side_weapons[w_tank_highlighted_index].weapon != null:
						highlighted_area = W_TANK_WEAPONS_LEFT
						menu_tick_sound.play()
						var start_pos = Vector2(left_side_weapons[w_tank_highlighted_index].rect_global_position.x,left_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
						w_tank_sprite.global_position = start_pos
					else:
						#loop through all the right side and select the first in the list.
						for i in left_side_weapons.size()-1:
							if left_side_weapons[i].weapon != null:
								w_tank_highlighted_index = i
								var start_pos = Vector2(left_side_weapons[w_tank_highlighted_index].rect_global_position.x,left_side_weapons[w_tank_highlighted_index].rect_global_position.y + 9)
								w_tank_sprite.global_position = start_pos
								highlighted_area = W_TANK_WEAPONS_LEFT
								menu_tick_sound.play()
								break
				if Input.is_action_just_pressed("action_shoot_p1"):
					$Audio/Page_Swap.play()
					highlighted_area = TANKS
					w_tank_highlighted_index = 0
					w_tank_sprite.hide()
					w_tank_sprite.stop()
				if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
					_use_w_tank(right_side_weapons,w_tank_highlighted_index)
		elif current_page== PAGE_TWO:
			if highlighted_area == FUNCTION_BUTTONS:
				if highlighted_index == 0:
					if (PlayerValues.has_stage_exit or has_infinite_lives )and Input.is_action_just_pressed("ui_right"):
						menu_tick_sound.play()
						highlighted_index = 1
						_function_button_selection_changed(highlighted_index)
					if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
						close_menu()
				if highlighted_index == 1:
					if Input.is_action_just_pressed("ui_left"):
						menu_tick_sound.play()
						highlighted_index = 0
						_function_button_selection_changed(highlighted_index)
					if Input.is_action_just_pressed("action_enter_p1") or Input.is_action_just_pressed("action_jump_p1"):
						if !PlayerValues.game_mode == "time_trial":
							if !can_exit_stage:
								$Audio/Error.play()
							else:
								get_tree().paused = false
								Physics.is_game_paused = false
								Physics.is_in_pausible_state = true
								yield(get_tree().create_timer(0.1),"timeout")
								get_tree().change_scene("res://scenes/menus/BossSelect.tscn")
						else:
							$Audio/Error.play()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func open_menu():
	if can_pause:
		instantiate()
		can_pause = false
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),WAIT_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		$score.text = str(PlayerValues.score)
		weapons = [weapon0,weapon1,weapon2,weapon3,weapon4,weapon5,weapon6,weapon7,weapon8,weapon9,weapon10,weapon11]
		highlighted_area = WEAPONS_LEFT
		highlighted_index = DEFAULT
		$Audio/Menu_Open.play()
		$Background/GridLines.material.set_shader_param("horizontal_speed", 0.45)
		$Background/GridLines.material.set_shader_param("vertical_speed", -0.5)
		if PlayerValues.has_ability_slot_1 or PlayerValues.game_mode == "rogue":
			$"Menu_Left/Ram Slots/Ram1".hide()
		if PlayerValues.has_ability_slot_2 or PlayerValues.game_mode == "rogue":
			$"Menu_Left/Ram Slots/Ram2".hide()
		if PlayerValues.game_mode == "rogue":
			$"Menu_Left/Rogue_Items".show()
			$"Menu_Left/Letters_Container".hide()
		var number_of_letters = 0
		for letter in PlayerValues.found_letters.size():
			if PlayerValues.found_letters["letter_" + str(letter+1)]:
				var node_name = "Menu_Left/Letters_Container/HBoxContainer/Letter_Slot_"+ str(letter + 1) +"/Letter_" + str(letter + 1)
				get_node(node_name).show()
				number_of_letters +=1
			if number_of_letters == 8:
				PlayerValues.is_serenade_unlocked = true
				$Menu_Left/Letters_Container.hide()

		emit_signal("game_paused")
		PlayerValues.player._charge_sound.pause_mode = Node.PAUSE_MODE_INHERIT
		get_tree().paused = true
		Physics.is_game_paused = true

		lives.text = "0" + str(PlayerValues.lives) if not Config.default_lives == -100 else "♾--"
		e_tanks.text = "0" + str(PlayerValues.e_tanks)
		w_tanks.text = "0" + str(PlayerValues.w_tanks)
		m_tanks.text = "0" + str(PlayerValues.m_tanks)
		bolts.text = str(PlayerValues.bolts).pad_zeros(5)
		knockback.text = "x" + str(PlayerValues.player.knock_back_multiplier)
		damage.text = "x" + str(PlayerValues.player.damage_multiplier)
		$AnimationPlayer.play("RESET")
		current_page = 1
		var index = 0
		for weapon in PlayerValues.obtained_weapons.values():
			if weapon != null:
				if index == 0:
					weapons[index].set_weapon_special(PlayerValues.health)
				else:
					weapons[index].set_weapon()

				if weapon.is_equipped:
					weapons[index].set_active()
					var side_index = 0
					for lsw in left_side_weapons:
						if lsw.weapon == weapon:
							highlighted_index = side_index
							highlighted_area = WEAPONS_LEFT
						side_index += 1
					side_index = 0
					for rsw in right_side_weapons:
						if rsw.weapon == weapon:
							highlighted_index = side_index
							highlighted_area = WEAPONS_RIGHT
						side_index += 1
				else:
					weapons[index].set_inactive()
			index += 1
		yield($Tween,"tween_all_completed")
		is_paused = true
		can_pause = true
#		show()
		can_user_control = true

func close_menu():
	if is_paused and can_user_control:
		$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),WAIT_TIME,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		can_user_control = false

		$Audio/Menu_Open.play()
		if highlighted_area == WEAPONS_LEFT:
			_on_weapon_changed(left_side_weapons[highlighted_index].weapon.key_name)
		elif highlighted_area == WEAPONS_RIGHT:
			_on_weapon_changed(right_side_weapons[highlighted_index].weapon.key_name)
#		hide()
		yield($Tween,"tween_all_completed")
		is_paused = false
		PlayerValues.player._charge_sound.pause_mode = Node.PAUSE_MODE_PROCESS
		get_tree().paused = false
		emit_signal("game_resumed")
		$Background/GridLines.material.set_shader_param("horizontal_speed", 0.0)
		$Background/GridLines.material.set_shader_param("vertical_speed", 0.0)

		Physics.is_game_paused = false
		if highlighted_area == FUNCTION_BUTTONS:
			PlayerValues.player.die()
			Physics.is_in_pausible_state = false

func instantiate():
	weapons = [weapon0,weapon1,weapon2,weapon3,weapon4,weapon5,weapon6,weapon7,weapon8,weapon9,weapon10,weapon11]
	left_side_weapons = [weapon0,weapon1,weapon2,weapon3,weapon4,weapon10]
	right_side_weapons = [weapon5,weapon6,weapon7,weapon8,weapon9,weapon11]
	var index = 0
	for weapon in PlayerValues.obtained_weapons.values():
		if weapon == null:
			(weapons[index]).hide()
		else:
			weapons[index].weapon = weapon
			weapons[index].is_weapon_obtained = true
			weapons[index].set_icon()
			weapons[index].set_weapon()
			if index == 0:
				weapons[index].set_weapon_special(PlayerValues.health)
			weapons[index].show()
		index += 1

	if Physics.current_stage.get("BOSS_NAME") != null and  Physics.current_stage.BOSS_NAME == "auto":
		can_exit_stage = false
	if Physics.current_stage.get("BOSS_NAME") != null and !has_infinite_lives:
		if Physics.current_stage.BOSS_NAME == "auto":
			can_exit_stage = false
		elif PlayerValues.beat_levels[Physics.current_stage.BOSS_NAME] == false:
			can_exit_stage = false
	elif Physics.current_stage.get("BOSS_NAME") == null:
		if !has_infinite_lives or PlayerValues.game_mode == "challenge":
			can_exit_stage = false
	if has_infinite_lives:
		exit_item.texture = load("res://assets/images/sprites/menus/exit_gold.png")
	if !can_exit_stage:
		exit_item.texture = load("res://assets/images/sprites/menus/exit_disabled.png")

	if !PlayerValues.game_mode == "time_trial":
		exit_item.show() if (PlayerValues.has_stage_exit or has_infinite_lives) else exit_item.hide()
	slide_item.show() if PlayerValues.can_slide else slide_item.hide()
	charge_item.show() if PlayerValues.can_charge else charge_item.hide()
	super_charge_item.show() if PlayerValues.can_max_charge else super_charge_item.hide()
	shock_absorber_item.show() if PlayerValues.shock_absorber_inventory_count > 0 else shock_absorber_item.hide()
	bolt_attractor_item.show() if PlayerValues.has_bolt_up_item else bolt_attractor_item.hide()
	energy_balancer_item.show() if PlayerValues.has_energy_balancer else energy_balancer_item.hide()
	energy_balancer_neo_item.show() if PlayerValues.has_energy_balancer_neo else energy_balancer_neo_item.hide()
	ability_slot_a_item.show() if PlayerValues.has_ability_slot_1 else ability_slot_a_item.hide()
	ability_slot_b_item.show() if PlayerValues.has_ability_slot_2 else ability_slot_b_item.hide()



#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _change_focus(weapon_side:Array, index:int)->void:
	for weapon in weapons:
		weapon.set_inactive()
	if not index == -1:
		weapon_side[index].set_active()

func _function_button_selection_changed(index:int):
	if index == 0 :
		function_button_description_box.text = tr("PAUSE_MENU_SELF_DESTRUCT")
		$Menu_Right/Selection_Icon.global_position = $Menu_Right/Function_Buttons/Self_Destruct/Position2D.global_position
	elif index == 1:
		function_button_description_box.text = tr("PAUSE_MENU_EXIT")
		$Menu_Right/Selection_Icon.global_position = $Menu_Right/Function_Buttons/Stage_Exit/Position2D.global_position

func _use_e_tank():
	if PlayerValues.player and PlayerValues.e_tanks > 0 and \
			PlayerValues.health < PlayerValues.MAX_HEALTH:
		can_user_control = false
		var health_before = PlayerValues.health
		PlayerValues.use_e_tank()
		PlayerValues.player.heal(PlayerValues.MAX_HEALTH)
		e_tanks.text = "0" + str(PlayerValues.e_tanks)
		while  health_before != PlayerValues.health:
			health_before += 1
			yield(get_tree().create_timer(TANK_FILL_DELAY), "timeout")
			weapons[0].set_weapon_special(health_before)
		can_user_control = true
	else:
		$Audio/Error.play()

func _go_into_w_tank_mode():
	if PlayerValues.w_tanks > 0:
		var i = 0
		for w in left_side_weapons:
			#skip mega buster
			if i == 0:
				i += 1
				continue
			if w.weapon != null:
				$Audio/Page_Swap.play()
				yield(get_tree().create_timer(0.25),"timeout")
				highlighted_area = W_TANK_WEAPONS_LEFT
				w_tank_highlighted_index = i
				var start_pos = Vector2(w.rect_global_position.x,w.rect_global_position.y + 9)
				w_tank_sprite.show()
				w_tank_sprite.play("default")
				w_tank_sprite.global_position = start_pos
				return
			i += 1
		if  highlighted_area != W_TANK_WEAPONS_LEFT:
			i = 0
			for w in right_side_weapons:
				if w.weapon != null:
					$Audio/Page_Swap.play()
					yield(get_tree().create_timer(0.25),"timeout")
					highlighted_area = W_TANK_WEAPONS_RIGHT
					w_tank_highlighted_index = i
					var start_pos = Vector2(w.rect_global_position.x,w.rect_global_position.y + 9)
					w_tank_sprite.show()
					w_tank_sprite.play("default")
					w_tank_sprite.global_position = start_pos
					return
			i += 1
	$Audio/Error.play()

func _use_w_tank(weapons:Array, index):
	if PlayerValues.player and PlayerValues.w_tanks > 0 and \
			(weapons[index].weapon.ammo != PlayerValues.NO_LIMIT and weapons[index].weapon.ammo < PlayerValues.MAX_HEALTH):
		can_user_control = false
		var ammo_before = weapons[index].weapon.ammo
		PlayerValues.use_w_tank(weapons[index].weapon.key_name)
		w_tanks.text = "0" + str(PlayerValues.w_tanks)
		PlayerValues.player.change_weapon(str("weapon_", weapons[index].weapon.key_name))
		PlayerValues.player.charge_weapon(PlayerValues.MAX_HEALTH, true)
		while  ammo_before != weapons[index].weapon.ammo:
			$Audio/ammo_sound.play(0.0)
			ammo_before = clamp(ammo_before + 1,0,PlayerValues.MAX_HEALTH)
			yield(get_tree().create_timer(TANK_FILL_DELAY), "timeout")
			weapons[index].set_weapon_special(ammo_before)
		$Audio/ammo_sound.stop()
		can_user_control = true
		highlighted_area = TANKS
		w_tank_sprite.hide()
		w_tank_sprite.stop()
	else:
		$Audio/Error.play()

func _use_m_tank():
	var str_i = str(w_tank_highlighted_index)
	var is_ok_to_m_tank = false
	if PlayerValues.player and PlayerValues.m_tanks > 0:
		if PlayerValues.health < PlayerValues.MAX_HEALTH:
			is_ok_to_m_tank = true
		if not is_ok_to_m_tank:
			for w in PlayerValues.obtained_weapons.values():
				if w != null:
					if w.ammo != PlayerValues.NO_LIMIT and w.ammo < PlayerValues.MAX_HEALTH:
						is_ok_to_m_tank = true
	if is_ok_to_m_tank:
		can_user_control = false

		#heal health first
		var health_before = PlayerValues.health
		PlayerValues.player.heal(PlayerValues.MAX_HEALTH)
		e_tanks.text = "0" + str(PlayerValues.e_tanks)
		while  health_before != PlayerValues.health:
			health_before =  clamp(health_before + 1, 0 , PlayerValues.MAX_HEALTH)
			yield(get_tree().create_timer(TANK_FILL_DELAY), "timeout")
			weapons[0].set_weapon_special(health_before)

		for weapon in left_side_weapons:
			if weapon.weapon != null and weapon.weapon.ammo != PlayerValues.NO_LIMIT:
				var ammo_before = weapon.weapon.ammo
				for PVweapon in PlayerValues.obtained_weapons.values():
					if PVweapon != null and PVweapon.key_name == weapon.weapon.key_name:
						PVweapon.ammo = PlayerValues.MAX_HEALTH
						break

				PlayerValues.player.change_weapon(str("weapon_", weapon.weapon.key_name))
				PlayerValues.player.charge_weapon(PlayerValues.MAX_HEALTH,true)
				while  ammo_before != weapon.weapon.ammo:
					$Audio/ammo_sound.play(0.0)
					ammo_before =  clamp(ammo_before + 1, 0 , PlayerValues.MAX_HEALTH)
					yield(get_tree().create_timer(TANK_FILL_DELAY), "timeout")
					weapon.set_weapon_special(ammo_before)
		for weapon in right_side_weapons:
			if weapon.weapon != null and weapon.weapon.ammo != PlayerValues.NO_LIMIT:
				var ammo_before = weapon.weapon.ammo
				for PVweapon in PlayerValues.obtained_weapons.values():
					if PVweapon != null and PVweapon.key_name == weapon.weapon.key_name:
						PVweapon.ammo = PlayerValues.MAX_HEALTH
						break

				PlayerValues.player.change_weapon(str("weapon_", weapon.weapon.key_name))
				PlayerValues.player.charge_weapon(PlayerValues.MAX_HEALTH,true)
				while  ammo_before != weapon.weapon.ammo:
					$Audio/ammo_sound.play(0.0)
					ammo_before = clamp(ammo_before + 1, 0 , PlayerValues.MAX_HEALTH)
					yield(get_tree().create_timer(TANK_FILL_DELAY), "timeout")
					weapon.set_weapon_special(ammo_before)
		$Audio/ammo_sound.stop()
		PlayerValues.use_m_tank()
		m_tanks.text = "0" + str(PlayerValues.m_tanks)
		can_user_control = true

	else:
		$Audio/Error.play()

func _default_page_1():
	highlighted_area = WEAPONS_LEFT
	highlighted_index = DEFAULT
	_change_focus(left_side_weapons,highlighted_index)

func _default_page_2():
	_change_focus([],-1)
	highlighted_area = FUNCTION_BUTTONS
	highlighted_index = DEFAULT
	w_tank_highlighted_index = DEFAULT
	$Menu_Left/Tanks_Container/W_Tank_Sprite.stop()
	$Menu_Left/Tanks_Container/W_Tank_Sprite.hide()
	_function_button_selection_changed(highlighted_index)
	if tank_selection.playing:
		tank_selection.stop()
		tank_selection.hide()

func _get_weapon_icon(weapon_name:String)->String:
	var weapon_icon_file = "res://assets/images/sprites/menus/not_applicable.png"
	match weapon_name:
		"shattered_diamond":
			weapon_icon_file= "res://assets/images/weapon icons/single_tile_weapon_icons/shattered_diamond.png"
		"silhouette_kunai":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/kunai.png"
		"buckler_barrage":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/bucker_single_icon.png"
		"mine_sweeper":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/mine_sweeper.png"
		"maelstrom_absorber":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/maelstrom_absorber_icon.png"
		"coal_ignition":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/coal_ignition.png"
		"tremor_pulse":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/earthquake.png"
		"wrecking_beam":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/wrecking_beam_single.png"
		"serenade_tone":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/serenade_tones_single.png"
		"mega_buster":
			weapon_icon_file = "res://assets/images/weapon icons/single_tile_weapon_icons/buster.png"
	return weapon_icon_file
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func _on_weapon_changed(bar_name: String) -> void:
	PlayerValues.player.change_weapon(str("weapon_", bar_name))

func _on_animation_finished(anim_name):
	can_user_control = true

func set_can_pause(value):
	can_pause = value

func on_collect_music_upgrade():
	music_upgrade_item.show() if PlayerValues.has_music_upgrade else music_upgrade_item.hide()
