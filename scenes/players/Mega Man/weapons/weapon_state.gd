extends "res://scenes/players/base/weapon_state_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
#add additional animation names here
const ANIMATIONS = ["Shoot","Shoot_Alt","Kick","Flex","Non_Shoot","Hold_Shoot", "Slash"]
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
#this needs to point to the animation name above
enum animation {shoot,throw,kick,flex,non_shoot,hold_shoot,slash}
export(String) var weapon_name := ""
export(float) var energy_cost:float = 1.0
export(Color) var color_primary: Color
export(Color) var color_secondary: Color

var weapon_energy: float = float(PlayerValues.MAX_HEALTH) setget , _get_weapon_energy
var is_weapon_hold_to_shoot:bool = false
var is_input_held:bool = false
var pause_on_floor:bool = false
var anim_name:String = ANIMATIONS[animation.shoot]
var _charge_playback_position: float = 0.0
var _weapon_reference_index:int

onready var charge_sound: AudioStreamPlayer = get_node("../../Audio/ChargeWeapon")
onready var animation_player: AnimationPlayer = get_node("../../AnimationPlayer")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	 _set_equipped_weapon("0")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func can_use()->bool:
	return true

func charge_energy(amount: int, ignore_energy_balancer:bool = false) -> void:
	if amount > 0:
		if weapon_energy >= 28:
				check_for_weapon_balancer(amount, ignore_energy_balancer)
		else:
			weapon_energy = int(clamp(weapon_energy + amount, 0, PlayerValues.MAX_HEALTH))
			PlayerValues.add_ammo(str(_weapon_reference_index), amount)
			#PlayerValues.obtained_weapons[str(_weapon_reference_index)].ammo = weapon_energy
			owner.emit_signal("weapon_energy_changed", weapon_energy)
	else:
		weapon_energy = int(clamp(weapon_energy + amount, 0, PlayerValues.MAX_HEALTH))
		PlayerValues.add_ammo(str(_weapon_reference_index), amount)
		owner.emit_signal("weapon_energy_changed", weapon_energy)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_weapon_energy() -> float:
	return weapon_energy

func _get_weapon_reference_index()->void:
	var i = 0
	for w in PlayerValues.obtained_weapons.values():
		if not w == null and w.full_name == weapon_name:
			_weapon_reference_index = i
		i+=1
		
func check_for_weapon_balancer(_amount,ignore_energy_balancer:bool = false):
	if !ignore_energy_balancer:
		if PlayerValues.has_energy_balancer and not PlayerValues.has_energy_balancer_neo :
			var lowest_id = "0"
			var lowest_value = 28
			for i in PlayerValues.obtained_weapons:
				if i == "0":
					continue
				if PlayerValues.obtained_weapons[i] != null:
					if PlayerValues.obtained_weapons[i].ammo < lowest_value:
						lowest_value = PlayerValues.obtained_weapons[i].ammo
						lowest_id = i
			PlayerValues.add_ammo(lowest_id, _amount)
		elif PlayerValues.has_energy_balancer_neo:
			for i in PlayerValues.obtained_weapons:
				PlayerValues.add_ammo(i, _amount)
			
# When weapon is exited the defaul weapon state gets equipped which is [0: Buster]
func _exit():
	_set_equipped_weapon(0)
	._exit()

func _enter() -> void:
	owner.swap_color(color_secondary,color_primary)
	_set_equipped_weapon(_weapon_reference_index)
	weapon_energy = PlayerValues.obtained_weapons[str(_weapon_reference_index)].ammo
	owner.emit_signal("weapon_changed", weapon_energy, color_primary, color_secondary)

	if not can_power_charge:
		owner.buffering_charge = false
		owner._cancel_charge()
	
	if not is_weapon_hold_to_shoot:
		is_input_held = false

func is_holding_shoot() -> bool:
	return is_input_held and _is_shooting()

func _process_update(delta: float) -> void:
	if not PlayerValues.can_charge and not is_weapon_hold_to_shoot:
		return

	if is_weapon_hold_to_shoot and _is_shooting():
		is_input_held = true
	elif is_weapon_hold_to_shoot and _is_idling():
		is_input_held = false
		_release()

	if can_power_charge and weapons.is_holding_shoot() and not owner.is_dead:
		if _charge_playback_position != 0:
			pass
#			charge_sound.play(_charge_playback_position)˚

		if (owner.charge_duration <= Physics.CHARGE_DURATION_LVL1
				and owner.charge_duration + delta > Physics.CHARGE_DURATION_LVL1):
			if not charge_sound.playing:
				charge_sound.play()
			owner.play_special_animation("power_charge_lvl1")
		if (owner.charge_duration <= Physics.CHARGE_DURATION_LVL2
				and owner.charge_duration + delta > Physics.CHARGE_DURATION_LVL2):
			owner.play_special_animation("power_charge_lvl2")
		if PlayerValues.can_max_charge and (owner.charge_duration <= Physics.CHARGE_DURATION_LVL3
				and owner.charge_duration + delta > Physics.CHARGE_DURATION_LVL3):
			owner.play_special_animation("power_charge_lvl3")

		owner.charge_duration += delta
		# loop charged shot audio
#		if charge_sound.get_playback_position() >= 2.3:
#			charge_sound.play(1.5)
	elif not owner.buffering_charge:
		owner._cancel_charge()

	_charge_playback_position = 0.0

#overwrite as needed. 
func _release():
	pass

func _deplete_energy() -> bool:
	if weapon_energy == 0.0:#  weapon_energy - energy_cost < 0:
		return false
	else:
		weapon_energy = clamp(weapon_energy - energy_cost, 0, 28)
		PlayerValues.sub_ammo(str(_weapon_reference_index), energy_cost)
		owner.emit_signal("weapon_energy_changed", ceil(weapon_energy))
		return true

func _set_equipped_weapon(index):
	for w in PlayerValues.obtained_weapons.values():
		if not w == null and w.is_equipped:
			w.is_equipped = false
	#after clearing all equipped weapons, set the current weapon to true
	PlayerValues.obtained_weapons[str(index)].is_equipped = true

func _is_shooting() -> bool:
	if _auto_fire_mode >= Config.AUTO_FIRE_MODE.toggle:
		return _auto_fire_mode % Config.AUTO_FIRE_MODE.toggle
	else:
		return inputs.is_action_pressed(InputHandler.Action.SHOOT)

func _is_idling() -> bool:
	if _auto_fire_mode >= Config.AUTO_FIRE_MODE.toggle:
		return not (_auto_fire_mode % Config.AUTO_FIRE_MODE.toggle)
	else:
		return inputs.is_action_released(InputHandler.Action.SHOOT)

#-------------------------------------------------
#      Connections
#-------------------------------------------------
