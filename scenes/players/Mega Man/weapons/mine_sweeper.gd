extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/mine_sweeper/mine_sweeper.tscn")
const MINE_SWEEPER_MAX_COUNT:int = 1
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
	anim_name = ANIMATIONS[animation.shoot]

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use() -> bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("MineSweeperP%s" % owner.player_number)
	return on_screen_bullets.size() < MINE_SWEEPER_MAX_COUNT and weapon_energy > 0

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
	bullet.add_to_group("MineSweeperP%s" % owner.player_number)

	bullet.position = mega_buster.global_position
	$"../../CollisionShape2D/SuperArrowRayCast".cast_to.x =  17 * owner.get_facing_direction().x
	$"../../CollisionShape2D/SuperArrowRayCast".enabled = true
	$"../../CollisionShape2D/SuperArrowRayCast".force_raycast_update()
	if $"../../CollisionShape2D/SuperArrowRayCast".is_colliding():
		bullet.position.x = owner.global_position.x
	bullet.direction = owner.get_facing_direction()
	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
