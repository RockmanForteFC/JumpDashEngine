extends Node2D
#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(int, 0, 9999) var weight_no_drop := 120

const LifeEnergySmall: Resource = preload("res://scenes/pickups/SmallHealth.tscn")
export(int, 0, 9999) var weight_life_energy_small := 12

const LifeEnergyBig: Resource = preload("res://scenes/pickups/LargeHealth.tscn")
export(int, 0, 9999) var weight_life_energy_big := 8

const WeaponEnergySmall: Resource = preload("res://scenes/pickups/SmallAmmo.tscn")
export(int, 0, 9999) var weight_weapon_energy_small := 12

const WeaponEnergyBig: Resource = preload("res://scenes/pickups/LargeAmmo.tscn")
export(int, 0, 9999) var weight_weapon_energy_big := 8

const ExtraLife: Resource = preload("res://scenes/pickups/ExtraLife.tscn")
export(int, 0, 9999) var weight_extra_life := 1

const SmallBolt: Resource = preload("res://scenes/pickups/SmallBolt.tscn")
export(int, 0, 9999) var weight_small_bolt := 30

const LargeBolt: Resource = preload("res://scenes/pickups/LargeBolt.tscn")
export(int, 0, 9999) var weight_large_bolt := 10

const EnergyTank: Resource = preload("res://scenes/pickups/Tank.tscn")
export(int, 0, 9999) var weight_energy_tank := 0

var _accumulated_weight: int
var _is_tank:bool = false
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	if PlayerValues.has_bolt_up_item:
		weight_small_bolt *= 2
		weight_large_bolt *= 2 
	if PlayerValues.is_in_special_game_mode:
		weight_extra_life = 0
		weight_small_bolt = 0
		weight_large_bolt = 0
		weight_energy_tank = 0
		weight_no_drop = 60
		if PlayerValues.game_mode == "challenge":
			weight_life_energy_big = 0
			weight_life_energy_small = 0
			weight_weapon_energy_big = 0
			weight_weapon_energy_small = 0
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func drop_item() -> void:
	var item_drop = _roll_item()

	if item_drop:
		item_drop.can_despawn = true if not _is_tank else false
		var pos = Vector2(global_position.x, global_position.y -10)
		item_drop.global_position = pos
		item_drop.velocity.y = -140
		Physics.current_stage.call_deferred("add_child", item_drop)

func drop_specific_item(item:String) -> void:
	var item_drop = null
	
	if item == "E" or item == "W" or item == "M":
		item_drop = EnergyTank.instance()
		if item == "E":
			item_drop.TankType = item_drop.TANKS.E
		elif item == "W":
			item_drop.TankType = item_drop.TANKS.W
		elif item == "M":
			item_drop.TankType = item_drop.TANKS.M
		item_drop.HasGravity = true
	elif item == "Health":
		item_drop = LifeEnergyBig.instance()
	elif item == "Life":
		item_drop = ExtraLife.instance()
	
	if item_drop:
		item_drop.can_despawn = true 
		var pos = Vector2(global_position.x, global_position.y -10)
		item_drop.global_position = pos
		item_drop.velocity.y = -140
		Physics.current_stage.call_deferred("add_child", item_drop)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

func _roll_item() -> Node:
	var total_weight: int = (
		weight_no_drop
		+ weight_life_energy_small
		+ weight_life_energy_big
		+ weight_weapon_energy_small
		+ weight_weapon_energy_big
		+ weight_extra_life
		+ weight_energy_tank
		+ weight_small_bolt
		+ weight_large_bolt
	)

	var roll: int = 0
	if total_weight > 0:
		roll += Physics.rng.randi_range(1, total_weight)
	
	_accumulated_weight = weight_no_drop
	if (roll <= _accumulated_weight):
		return null

	_accumulated_weight += weight_life_energy_small
	if roll <= _accumulated_weight:
		return LifeEnergySmall.instance()

	_accumulated_weight += weight_life_energy_big
	if roll <= _accumulated_weight:
		return LifeEnergyBig.instance()

	_accumulated_weight += weight_weapon_energy_small
	if roll <= _accumulated_weight:
		return WeaponEnergySmall.instance()

	_accumulated_weight += weight_weapon_energy_big
	if roll <= _accumulated_weight:
		return WeaponEnergyBig.instance()

	_accumulated_weight += weight_extra_life
	if roll <= _accumulated_weight:
		return ExtraLife.instance()

	_accumulated_weight += weight_energy_tank
	if roll <= _accumulated_weight:
		_is_tank = true
		return EnergyTank.instance()
	
	_accumulated_weight += weight_small_bolt
	if roll <= _accumulated_weight:
		return SmallBolt.instance()
		
	_accumulated_weight += weight_large_bolt
	if roll <= _accumulated_weight:
		return LargeBolt.instance()

	return null
#-------------------------------------------------
#      Connections
#-------------------------------------------------
