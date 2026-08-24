extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#warning-ignore-all:return_value_discarded
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPEED_BOOST: Resource = preload("res://scenes/players/Mega Man/projectiles/speed_boost/speed_boost.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
onready var mega_buster: Position2D = get_node("../../MegaBusterPos")
var on_sceen_limit = 1
var sboost = null
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
func can_use_speed_boost()->bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("SpeedBoostProjectilesP%s" % owner.player_number)
	return on_screen_bullets.size() < on_sceen_limit

func can_use() ->bool:
	return weapon_energy > 0

func use() -> void:
	if can_use_speed_boost():

		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x

		sboost = SPEED_BOOST.instance()
		sboost.add_to_group("SpeedBoostProjectilesP%s" % owner.player_number)
		owner.get_parent().add_child(sboost)
		sboost.connect("speed_boost_ammo_tick", self, "on_speed_boost_ammo_tick")
	else:
		sboost.queue_free()
		sboost = null
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_speed_boost_ammo_tick(first_tick):
	_deplete_energy()
	if weapon_energy <= 0 and sboost != null:
		sboost.queue_free()
		sboost = null

