extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/mega_buster.tscn")
const ProjectileCharged1: Resource = preload("res://scenes/players/Mega Man/projectiles/mega_buster_charged_lvl1.tscn")
const ProjectileCharged2: Resource = preload("res://scenes/players/Mega Man/projectiles/mega_buster_charged_lvl2.tscn")
const ProjectileCharged3: Resource = preload("res://scenes/players/Mega Man/projectiles/mega_buster_charged_lvl3.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var mega_buster: Position2D = get_node("../../MegaBusterPos")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready() -> void:
	_get_weapon_reference_index()
	can_power_charge = true


#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func charge_energy(_amount: int, ignore_energy_balancer:bool = false) -> void:
	check_for_weapon_balancer(_amount,ignore_energy_balancer)

func can_use() -> bool:
	var bullets_weight: int = \
		get_tree().get_nodes_in_group("BusterProjectilesP%s" % owner.player_number).size() * 1 + \
		get_tree().get_nodes_in_group("BusterChargedProjectileP%s" % owner.player_number).size() * 3
	return bullets_weight < owner.max_on_screen_projectiles + \
		(3 if PlayerValues.equipped_upgrade == "mega_buster" else 0)

func use() -> void:
	if can_use():
		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet())

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet() -> Node:
	var bullet: Node
	match owner.charge_level:
		0:
			bullet = Projectile.instance()
			bullet.add_to_group("BusterProjectilesP%s" % owner.player_number)
		1:
			bullet = ProjectileCharged1.instance()
			bullet.add_to_group("BusterProjectilesP%s" % owner.player_number)
		2:
			bullet = ProjectileCharged2.instance()
			#This is a seperate group so that you can have 1 charge shot and 3 buster shots on screen at the same time.
			bullet.add_to_group("BusterChargedProjectileP%s" % owner.player_number)
		3:
			bullet = ProjectileCharged3.instance()
			#This is a seperate group so that you can have 1 charge shot and 3 buster shots on screen at the same time.
			bullet.add_to_group("BusterChargedProjectileP%s" % owner.player_number)
	bullet.position = mega_buster.global_position
	bullet.direction = owner.get_facing_direction()

	return bullet

func _get_weapon_energy() -> float:
	return float(owner.hit_points)

func _enter() -> void:
	owner.reset_color()
	owner.emit_signal("weapon_changed", 0, Color.transparent, Color.transparent)

func _deplete_energy() -> bool:
	return true  # Cannot deplete mega buster.

#-------------------------------------------------
#      Connections
#-------------------------------------------------
