extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/shachi_drone/shachi_drone.tscn")
const DOLPHIN_MAX_ON_SCREEN:int = 2
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
	var on_screen_bullets: Array = get_tree().get_nodes_in_group(
	"Shachi_DroneP%s" % owner.player_number)


	return on_screen_bullets.size() < DOLPHIN_MAX_ON_SCREEN 

func use() -> void:
	if can_use():

		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		var proj = Projectile.instance()
		proj.scale.y *= owner.gravity_direction.y
		proj.direction = owner.get_facing_direction() - owner.gravity_direction
		proj.add_to_group("Shachi_DroneP%s" % owner.player_number)

		proj.position = mega_buster.global_position
		proj.position.x += (10 * owner.get_facing_direction().x)
		owner.get_parent().add_child(proj)
		
		if not _deplete_energy():
			return
			
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet() -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.add_to_group("Shachi_DroneP%s" % owner.player_number)
	bullet.position.x = mega_buster.global_position.x + 10 * owner.get_facing_direction().x
	bullet.position.y = mega_buster.global_position.y

	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
