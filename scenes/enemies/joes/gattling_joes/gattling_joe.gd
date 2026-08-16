tool
extends "res://scenes/enemies/base/enemy_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHIELD_POSITION_X_LEFT = -10
const SHIELD_POSITION_X_RIGHT = 8
#-------------------------------------------------
#      Signals
#-------------------------------------------------
signal shield_hit
#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Color) var primary_color:Color = Color("58d854")
export(Color) var secondary_color:Color = Color("ffffff")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	if $Sprite.flip_h == true:
		$Shield/shield_collision.position.x = SHIELD_POSITION_X_RIGHT
	else:
		$Shield/shield_collision.position.x = SHIELD_POSITION_X_LEFT
	$Sprite.material.set_shader_param("replace_0", primary_color)
	$Sprite.material.set_shader_param("replace_1", secondary_color)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func toggle_flip_h():
	.toggle_flip_h()
	if $Sprite.flip_h == true:
		$Shield/shield_collision.position.x =  SHIELD_POSITION_X_RIGHT
	else:
		$Shield/shield_collision.position.x = SHIELD_POSITION_X_LEFT
		
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _replace_with_spawner() -> void:
	spawn_info["primary_color"] = primary_color
	spawn_info["secondary_color"] = secondary_color
	._replace_with_spawner()
#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_Shield_body_entered(body):
	if not is_dead:
		if body is Player:
			body.on_hit(contact_damage, damage_type, element)
		if body.is_in_group("PlayerWeapons"):
			emit_signal("shield_hit")
			if not body.is_piercing:
				body.reflect()
