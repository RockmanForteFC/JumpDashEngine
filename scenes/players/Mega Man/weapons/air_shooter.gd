extends "res://scenes/players/Mega Man/weapons/weapon_state.gd"
#-------------------------------------------------
#      Constants
#-------------------------------------------------
const Projectile: Resource = preload("res://scenes/players/Mega Man/projectiles/air_shooter/air_shooter.tscn")
const AIR_SHOOTER_MAX_ON_SCREEN:int = 1
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
	var on_screen_bullets: Array = get_tree().get_nodes_in_group("AirShooterP%s" % owner.player_number)
	return on_screen_bullets.size() < AIR_SHOOTER_MAX_ON_SCREEN and weapon_energy > 0
		
func use() -> void:
	if can_use():
		if not _deplete_energy():
			return
			
		mega_buster.position.x = abs(mega_buster.position.x) * owner.get_facing_direction().x
		owner.get_parent().add_child(_get_bullet(Vector2(65,0)))
		owner.get_parent().add_child(_get_bullet(Vector2(100,0)))
		owner.get_parent().add_child(_get_bullet(Vector2(140,0)))

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _get_bullet(speed) -> Node:
	var bullet: Node
	bullet = Projectile.instance()
	bullet.add_to_group("AirShooterP%s" % owner.player_number)

	bullet.position = mega_buster.global_position
	bullet.speed = speed
	bullet.direction = owner.get_facing_direction()
	return bullet

#-------------------------------------------------
#      Connections
#-------------------------------------------------
