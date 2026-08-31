extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/slash_claw/slash_claw.tscn")
const SLASH_CLAW_MAX_ON_SCREEN:int = 1
const X_OFFSET:int = 16
const Y_OFFSET:int = 4
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
	pause_on_floor = true
	anim_name = ANIMATIONS[animation.slash]

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func can_use() -> bool:
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("SlashClawP%s" % owner.player_number)
	return on_screen_bullets.size() < SLASH_CLAW_MAX_ON_SCREEN and weapon_energy > 0

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
	bullet.add_to_group("SlashClawP%s" % owner.player_number)

	bullet.position = mega_buster.global_position
	bullet.direction = owner.get_facing_direction()
	bullet.position.x = (mega_buster.position.x + X_OFFSET)
	bullet.position.y = (mega_buster.position.y + Y_OFFSET)
	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
