extends "res://globals/weapons.gd"

signal player_instanced(player)

#============================================================================================#
#	Constants
#============================================================================================#
const RUSH_COIL:String = "rush_coil"
const RUSH_JET:String = "rush_jet"
const CARRY:String = "carry"
const SUPER_ARROW:String = "super_arrow"

const BUSTER_SLOT:String = "0"
const BUCKLER_SLOT:String = "1"
const BEAM_SLOT:String = "2"
const KUNAI_SLOT:String = "3"
const COAL_SLOT:String = "4"
const TREMOR_SLOT:String = "5"
const DIAMOND_SLOT:String = "6"
const MAELSTROM_SLOT:String = "7"
const MINE_SLOT:String = "8"
const SERENADE_SLOT:String = "9"
const UTILITY_A_SLOT:String = "10"
const UTILITY_B_SLOT:String = "11"

const FORT_NONE = "none"
const FORT_ONE = "V1"
const FORT_TWO = "V2"
const FORT_THREE = "V3"
const FORT_FOUR = "V4"
const FORT_FIVE = "DW1"
const FORT_SIX = "DW2"
const FORT_SEVEN = "DW3"
const FORT_EIGHT = "DW4"
const FORT_NINE = "DW5"

#============================================================================================#
#	Player Values
#============================================================================================#
var player:Player setget _set_player
var health:int = MAX_HEALTH

var is_teleporting:bool = false
var is_in_special_game_mode:bool = false
var is_in_refights:bool = false
var special_mode = ""
var game_mode:String = "main"
var endless_screen_count:int = 0
var rogue_screen_count:int = 0
var is_on_weapon_get_screen:bool = false

var can_slide:bool = true
var can_charge:bool = true
var can_max_charge:bool = false
var can_double_jump:bool = false
var has_music_upgrade:bool = false

#powerups
#increases drop rate for bolts
var has_bolt_up_item:bool = false
var has_energy_balancer:bool = false
var has_energy_balancer_neo:bool = false
var has_book_of_weapons:bool = false
var has_stage_exit:bool = false
var has_cd_locator:bool = false
var shock_absorber_inventory_count:int = 0
var eddie_max = 3
var eddie_inventory_count:int = 1

#unlocks obtained_weapons [8] and [9]. Allow the player to customize what utilities they want to go into a level with.
var has_ability_slot_1:bool = false
var has_ability_slot_2:bool = false

var purchased_utilities:Array = [
	null,null,null,null,null,
	null,null,null,null,null
]

#this needs to be the key_name of the weapon
var equipped_upgrade:String = ""

# Start with 3 lives, max of 10
var lives:int = 2
var max_lives:int = 9
var max_e_tanks:int = 9
var max_w_tanks:int = 9
var max_m_tanks:int = 1
var e_tanks:int = 0
var m_tanks:int = 0
var w_tanks:int = 0
var bolts:int = 0

var fortress_position:String = FORT_NONE
var is_serenade_unlocked:bool = false
var is_mid_game_cutscene_seen:bool = false
var is_eight_boss_cutscene_seen:bool = false
var is_in_virus_fortress:bool = false
var is_in_wily_fortress:bool = false

#this can be used for engine levels
var card_level:int = 0

var session_playtime:float = 0.0
var _is_timer_running:bool = false
var equiped_weapon = buster
var last_played_level
var boss_display_name = ""
#this will show up in the weapon get screen
var newly_obtained_weapon_name = ""

# 8 letter word with 1 letter in each level
var found_letters:Dictionary = {
	"letter_1":false,
	"letter_2":false,
	"letter_3":false,
	"letter_4":false,
	"letter_5":false,
	"letter_6":false,
	"letter_7":false,
	"letter_8":false,
	}

var beat_levels:Dictionary = {
	"a_man": false,
	"c_man":false,
	"d_man": false,
	"example_level":false,
	"e_man":false,
	"f_man":false,
	"g_man":false,
	"b_woman":false,
	"h":false
}

enum fortress_levels {
	L_1 = 0,
	L_2 = 1,
	L_3 = 2,
	L_4 = 3,
	L_5 = 4,
	L_6 = 5,
	L_7 = 6,
	L_8 = 7,
	L_9 = 8
}
var current_fortress_level:int = fortress_levels.L_1
#============================================================================================#
#	Hidden from user
#============================================================================================#
# Keeps track of how a user plays the game
var score:int = 0
var item_queue:Array = []
#============================================================================================#
#	Weapons
#============================================================================================#
var obtained_weapons = {
	"0": buster,
	"1": laser_trident, #brawler
	"2": skull_barrier, #beam
	"3": air_shooter, #ninja
	"4": blazing_torch, #incinerate
	"5": null, #tremor
	"6": block_dropper, #arctic
	"7": gyro_attack, #maelstrom
	"8": slash_claw, #detonate
	"9": null, #Letter Collection
	"10": rush_coil, #utility A
	"11": rush_jet  #utility B
}

func setup_new_default_play_params():
	reset_all_params_to_default()
	set_buster_only_weapon()

#============================================================================================#
#	Processes
#============================================================================================#
func _process(delta):
	if _is_timer_running:
		session_playtime += delta
	if !item_queue.empty() and Physics.is_in_pausible_state:
		item_queue = []
	elif !item_queue.empty() and !Physics.is_in_pausible_state:
		pass
#============================================================================================#
#	Functions
#============================================================================================#
# After every level we will refil everything
func refill_everything():
	health = MAX_HEALTH
	for w in obtained_weapons:
		if not obtained_weapons[w] == null and obtained_weapons[w].ammo != NO_LIMIT:
			obtained_weapons[w].ammo = MAX_HEALTH

# Starting in the wily stages we will refil only health.
func refill_all_health():
	health = MAX_HEALTH

func sub_health(hp:int):
	health = health - hp

# using an intermediary variable to store health so that you cannot blip your health more than 28 for the UI to look funky.
func add_health(hp:int):
	health = int(clamp(health + hp, 0, MAX_HEALTH))

# using an intermediary variable to store ammo so that you cannot blip your health more than 28 for the UI to look funky.
func add_ammo(weapon_id:String, ammo:int):
	var ammoScore = Score.HEALTH_AMMO_PICKUP_SCORE
	if obtained_weapons[weapon_id] != null:
		var weapon_ammo = obtained_weapons[weapon_id].ammo
		weapon_ammo = clamp(weapon_ammo + ammo,0 ,MAX_HEALTH)
	#	if weapon_ammo > MAX_HEALTH:
	#		obtained_weapons[weapon_id].ammo = MAX_HEALTH
	#	else:
	#		obtained_weapons[weapon_id].ammo = weapon_ammo
		obtained_weapons[weapon_id].ammo = weapon_ammo

func sub_ammo(weapon_id:String, ammo:float):
	if not obtained_weapons[weapon_id].ammo == NO_LIMIT:
		obtained_weapons[weapon_id].ammo = obtained_weapons[weapon_id].ammo - ammo
		if obtained_weapons[weapon_id].ammo < 0:
			obtained_weapons[weapon_id].ammo = 0

func die():
	Score.change(Score.DEATH)
	if not Config.default_lives == -100:
		lives -= 1
	if Config.default_lives == -100:
		lives = -100

func add_extra_life():
	if not lives == -100 and not lives == 9:
		lives = lives + 1
	if Config.default_lives == -100:
		lives = -100
	Score.change(Score.EXTRA_LIFE_GET)

func add_tank(tank_type:String):
	if tank_type == 'E' and e_tanks < max_e_tanks:
		e_tanks += 1
	if tank_type == 'M' and m_tanks < max_m_tanks:
		m_tanks += 1
	if tank_type == 'W' and w_tanks < max_w_tanks:
		w_tanks += 1
	Score.change(Score.TANK_PICKUP_GET)

func use_e_tank():
	if e_tanks >= 1:
		e_tanks = e_tanks - 1
		Score.change(Score.TANK_USED)

func use_m_tank():
	if m_tanks >= 1:
		m_tanks = m_tanks - 1
		refill_everything()
		Score.change(Score.TANK_USED)

func use_w_tank(key_name:String):
	if w_tanks >= 1:
		w_tanks = w_tanks - 1
		for weapon in obtained_weapons.values():
			if weapon != null and weapon.key_name == key_name:
				weapon.ammo = MAX_HEALTH
		Score.change(Score.TANK_USED)

func gameover():
	player = null
	lives = Config.default_lives
	refill_everything()
	Score.change(Score.GAME_OVER)

func are_weapons_full():
	var are_all_full = true
	for i in obtained_weapons:
		if obtained_weapons[str(i)] == null or obtained_weapons[str(i)].ammo == NO_LIMIT:
			continue
		if obtained_weapons[str(i)].ammo < MAX_HEALTH:
			are_all_full = false
			break
	return are_all_full

func start_game_timer()->void:
	_is_timer_running = true

func pause_game_timer()->void:
	_is_timer_running = false

func get_playtime(is_short_form:bool = false)->String:
	#var miliseconds = fmod(session_playtime,1)*1000
	var seconds = fmod(session_playtime,60)
	var minutes = fmod(session_playtime, 60*60) /60
	var hours = fmod( fmod(session_playtime,3600*60)/3600, 500)

	return "%03d:%02d:%02d" % [hours,minutes,seconds] if not is_short_form else "%02d:%02d" % [hours,minutes]


#===============================================================
#Challenge Settings
#===============================================================

func _prepare_for_challenge():
	reset_all_params_to_default()
	lives = 0
	obtained_weapons["1"].ammo = MAX_HEALTH
	for i in 11:
		if i > 0:
			obtained_weapons[str(i+1)] = null

func reset_all_params_to_default(reset_upgrade:bool = true):
	lives = Config.default_lives
	health = MAX_HEALTH
	score = 0
	e_tanks = 0
	m_tanks = 0
	w_tanks = 0
	bolts = 0
	beat_levels = {
		"a_man": false,
		"c_man":false,
		"d_man": false,
		"example_level":false,
		"e_man":false,
		"f_man":false,
		"g_man":false,
		"b_woman":false,
		"h":false
	}
	is_eight_boss_cutscene_seen = false
	is_in_virus_fortress = false
	is_in_wily_fortress = false
	fortress_position = FORT_NONE
	current_fortress_level = fortress_levels.L_1
	if reset_upgrade:
		equipped_upgrade = ""
	is_mid_game_cutscene_seen = false
	is_serenade_unlocked = false

	#not implemented
	eddie_inventory_count = 0

	#protects you from dying on spike once
	shock_absorber_inventory_count = 0

	#this is the utility slots. if false, they need to be obtained
	has_ability_slot_1 = true
	has_ability_slot_2 = true

	has_cd_locator = false

	#increases drop rate of bolts
	has_bolt_up_item = false

	#lets the player exit a stage
	has_stage_exit = false

	has_energy_balancer = false
	has_energy_balancer_neo = false
	can_charge = false
	can_max_charge = false
	can_double_jump = false
	has_music_upgrade = false
	session_playtime = 0
	for i in purchased_utilities.size():
		purchased_utilities[i] = null
	for i in beat_levels:
		beat_levels[i] = false
	for i in found_letters:
		found_letters[i] = false

func set_buster_only_weapon():
	reset_all_params_to_default()
	obtained_weapons[PlayerValues.BUSTER_SLOT] = buster
	for i in 11:
		obtained_weapons[str(i+1)] = null

func _set_player(val: Player) -> void:
	player = val
	if is_instance_valid(player):
		emit_signal("player_instanced", player)
