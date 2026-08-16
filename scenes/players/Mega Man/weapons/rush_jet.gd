extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#warning-ignore-all:return_value_discarded
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Rush: Resource = preload("res://scenes/players/Mega Man/projectiles/rush_jet/rush_jet.tscn")
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/mega_buster.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var mega_buster: Position2D = get_node("../../MegaBusterPos")
var rush_on_sceen_limit = 1
var buster_on_screen_limit = 3
var rush = null
#-------------------------------------------------
#      Processes
#-------------------------------------------------
func _ready():
	_get_weapon_reference_index()
	# This will be for the wily levels when ammo isn't recharged between levels. 
	weapon_energy = PlayerValues.obtained_weapons[str(_weapon_reference_index)].ammo
	anim_name = ANIMATIONS[animation.shoot]
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use_rush()->bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group(
	"RushJetProjectilesP%s" % owner.player_number)

	return on_screen_bullets.size() < rush_on_sceen_limit 

func can_use() ->bool:
	return weapon_energy > 0 and (can_use_rush() or can_use_buster())

func can_use_buster()->bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("RushBusterProjectilesP%s" % owner.player_number)
	return on_screen_bullets.size() < buster_on_screen_limit
	
func use() -> void:
	if can_use_rush():

		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x

		rush = Rush.instance()
		rush.direction = owner.get_facing_direction()
		rush.gravity_direction = owner.gravity_direction
		rush.add_to_group("RushJetProjectilesP%s" % owner.player_number)
		rush.position = mega_buster.global_position
		rush.position.x += (10 * owner.get_facing_direction().x)
		rush.position.y += -15 * rush.gravity_direction.y
		rush.scale *= Vector2(rush.direction.x, rush.gravity_direction.y)
		owner.get_parent().add_child(rush)
		rush.connect("rush_jet_ammo_tick", self, "on_rush_ammo_tick")
	elif can_use_buster():
		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		var bullet = Projectile.instance()
		bullet.add_to_group("RushBusterProjectilesP%s" % owner.player_number)
		bullet.position = mega_buster.global_position
		bullet.key_name = "rush_mega_buster"
		bullet.direction = owner.get_facing_direction()
		owner.get_parent().add_child(bullet)
		
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_rush_ammo_tick(first_tick):
	_deplete_energy()
	if weapon_energy <= 0 and rush != null:
		rush._deactivate()
		
