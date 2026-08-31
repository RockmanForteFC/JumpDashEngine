extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/carry/carry.tscn")
const CARRY_MAX_ON_SCREEN:int = 3
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

func _ready():
	_get_weapon_reference_index()
	anim_name = ANIMATIONS[animation.throw]

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use() -> bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("CarryP%s" % owner.player_number)
	return on_screen_bullets.size() < CARRY_MAX_ON_SCREEN and weapon_energy > 0

func use() -> void:
	if can_use():
		if not _deplete_energy():
			return

		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet())
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet() -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.scale.y *= owner.gravity_direction.y
	bullet.add_to_group("CarryP%s" % owner.player_number)
	if owner.is_on_floor() or owner.is_climbing:
		bullet.position.x = mega_buster.global_position.x + 10 * owner.get_facing_direction().x
		bullet.position.y = mega_buster.global_position.y
	else:
		bullet.position.x = owner.global_position.x
		bullet.position.y = mega_buster.global_position.y + 30

	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
