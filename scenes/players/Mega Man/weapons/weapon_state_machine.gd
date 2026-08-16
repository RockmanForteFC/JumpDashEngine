extends "res://scenes/players/base/weapons_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------


func _ready() -> void:
	_init_states_map()
	initialize(states_map[PlayerValues.obtained_weapons["0"].key_name].get_path())
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func change_weapon(name: String) -> void:
	if states_map.get(name.substr(7)) != current_state:
		_remove_on_screen_projectiles()
	PlayerValues.obtained_weapons[str(current_state._weapon_reference_index)].is_equipped = false
	if states_map.size() == 0:
		_init_states_map()
	if name == "weapon_next":
		_change_state(_get_adjacent_key())
		owner.emit_signal("weapon_changed_swap")
	elif name == "weapon_previous":
		_change_state(_get_adjacent_key(true))
		owner.emit_signal("weapon_changed_swap")
	elif name == "weapon_buster":
		_change_state(states_map.keys()[0])
		owner.emit_signal("weapon_changed_swap")
		# Remove weapon_ prefix. eg. weapon_M.Buster will become M.Buster
	elif states_map.keys().has(name.substr(7)):  
		_change_state(name.substr(7))
	else:
		printerr("Failed to change weapon. %s is not a valid weapon name." % name)

func get_weapons_info() -> Dictionary:
	var weapons_info := {}
	for key in states_map.keys():
		if "weapon_energy" in states_map[key] and "color_primary" and "color_secondary" in states_map[key]:
			weapons_info[key] = [states_map[key].weapon_energy, states_map[key].color_primary, states_map[key].color_secondary]

	return weapons_info
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _remove_on_screen_projectiles():
	if Config.clear_projectiles_on_swap: 
		for n in owner.get_parent().get_children():
			if n.is_in_group("PlayerWeapons"):
				if n.is_in_group("Shachi_DroneP%s" % owner.player_number):
					pass
				else:
					n.queue_free()
					#special exception for rush phase because it can cause you to stick in the ground
			if n.is_in_group("PlayerUtilities"):
				if n.is_in_group("RushCoilProjectilesP%s" % owner.player_number):
					n.queue_free()
				if n.is_in_group("RushJetProjectilesP%s" % owner.player_number):
					n.queue_free()
				if n.is_in_group("CarryP%s" % owner.player_number) :
					n.queue_free()
				if n.is_in_group("SpeedBoostProjectilesP%s" % owner.player_number) :
					n.queue_free()
				if n.is_in_group("Shachi_DroneP%s" % owner.player_number):
					#special exception for rush phase because it can cause you to stick in the ground
					pass
				if n.is_in_group("LifeSeedP%s" % owner.player_number):
					n.queue_free()
				
func _get_adjacent_key(previous: bool = false) -> String:
	var keys: Array = states_map.keys()
	var current_key: String

	for key in keys:
		if states_map[key] == current_state:
			current_key = key
	
	var adjacent_index: int = 0
	var current_index: int = keys.find(current_key)

	if current_index < 0:
		printerr("Failed to map weapon states key to currently equipped weapon state.")
	elif not previous and current_index == keys.size() - 1:
		adjacent_index = 0
	else:
		adjacent_index = current_index - 1 if previous else current_index + 1

	return keys[adjacent_index]

func reinit_state_map():
	_init_states_map()
	for node in get_children():
		node._get_weapon_reference_index()

func _init_states_map() -> void:
	states_map.clear()
	
	for weapon in PlayerValues.obtained_weapons.values():
		if not weapon == null:
			
			match weapon.key_name:
				"mega_buster": states_map[weapon.key_name] = $MegaBuster
				"rush_coil":states_map[weapon.key_name] = $RushCoil
				"rush_jet":states_map[weapon.key_name] = $RushJet
				"carry":states_map[weapon.key_name] = $Carry
				"speed_boost":states_map[weapon.key_name] = $SpeedBoost
				"laser_trident" : states_map[weapon.key_name] = $LaserTrident
				"bubble_lead": states_map[weapon.key_name] = $BubbleLead
				"water_balloon": states_map[weapon.key_name] = $WaterBalloon
				"blazing_torch": states_map[weapon.key_name] = $BlazingTorch
				"thunder_bolt": states_map[weapon.key_name] = $ThunderBolt
				"gemini_laser": states_map[weapon.key_name] = $GeminiLaser
				"drill_bomb": states_map[weapon.key_name] = $DrillBomb
				"hyper_bomb": states_map[weapon.key_name] = $HyperBomb
				"flame_blast": states_map[weapon.key_name] = $FlameBlast
				"skull_barrier":  states_map[weapon.key_name] = $SkullBarrier
				"star_crash":states_map[weapon.key_name] = $StarCrash
				"plant_barrier":  states_map[weapon.key_name] = $PlantBarrier
				"gyro_attack":  states_map[weapon.key_name] = $GyroAttack
				"shadow_blade":  states_map[weapon.key_name] = $ShadowBlade
				"metal_blade":  states_map[weapon.key_name] = $MetalBlade
				"arthurs_lance":  states_map[weapon.key_name] = $ArthursLance
				"shachi_drone":  states_map[weapon.key_name] = $ShachiDrone
				"life_seed": states_map[weapon.key_name] = $LifeSeed
				"super_arrow": states_map[weapon.key_name] = $SuperArrow
				"yamato_spear": states_map[weapon.key_name] = $YamatoSpear
				"rebound_striker": states_map[weapon.key_name] = $ReboundStriker
				"block_dropper": states_map[weapon.key_name] = $BlockDropper
				"solar_blaze":  states_map[weapon.key_name] = $SolarBlaze
				"crystal_eye":  states_map[weapon.key_name] = $CrystalEye
				"slash_claw":states_map[weapon.key_name] = $SlashClaw
				"shark_boomerang":states_map[weapon.key_name] = $SharkBoomerang
				"power_stone":states_map[weapon.key_name] = $PowerStone
				"hard_knuckle":states_map[weapon.key_name] = $HardKnuckle
				"silver_tomahawk":states_map[weapon.key_name] = $SilverTomahawk
				"air_shooter":states_map[weapon.key_name] = $AirShooter
				"wind_storm":states_map[weapon.key_name] = $WindStorm
				"napalm_bomb":states_map[weapon.key_name] = $NapalmBomb
	#states_map["mega_buster"] = $MegaBuster
#	if GameState.unlocked_weapons.has("electric_ball"):
#		states_map["electric_ball"] = $ElectricBall

#-------------------------------------------------
#      Connections
#-------------------------------------------------
