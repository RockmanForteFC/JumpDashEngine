extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/arthurs_lance/arthurs_lance.tscn")
const PULSE_MAX_ON_SCREEN:int = 3
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
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("ArthursLanceP%s" % owner.player_number)
	return on_screen_bullets.size() < PULSE_MAX_ON_SCREEN and weapon_energy > 0 
		
func use() -> void:
	if can_use():
		if not _deplete_energy():
			return
			
		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet())
		yield(get_tree().create_timer(0.2),"timeout")

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet() -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.add_to_group("ArthursLanceP%s" % owner.player_number)
	bullet.position = mega_buster.global_position
	bullet.direction = owner.get_facing_direction()

	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
