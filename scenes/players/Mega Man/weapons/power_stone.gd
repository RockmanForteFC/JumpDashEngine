extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/power_stone/power_stone.tscn")
const POWER_STONE_MAX_ON_SCREEB:int = 1
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
	anim_name = ANIMATIONS[animation.throw]

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use() -> bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("PowerStoneP%s" % owner.player_number)
	return on_screen_bullets.size() < POWER_STONE_MAX_ON_SCREEB and weapon_energy > 0 
		
func use() -> void:
	if can_use():
		if not _deplete_energy():
			return
			
		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet(Vector2(-1,-1)))
		owner.get_parent().add_child(_get_bullet(Vector2(0,1)))
		owner.get_parent().add_child(_get_bullet(Vector2(1,-1)))
		yield(get_tree().create_timer(0.2),"timeout")

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet(dir) -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.add_to_group("PowerStoneP%s" % owner.player_number)
	bullet.position = owner.global_position
	bullet.center = owner.global_position
	bullet.initial_direction = dir
	bullet.direction = owner.get_facing_direction()

	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
