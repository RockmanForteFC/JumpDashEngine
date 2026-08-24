extends "res://scenes/enemies/base/enemy_base.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------

#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export(Color) var primary_color:Color = Color("ffa044")
export(Color) var secondary_color:Color = Color("ffffff")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite.material.set_shader_param("replace_0", primary_color)
	$Sprite.material.set_shader_param("replace_1", secondary_color)
	if flip_direction == true:
		$Position2D.position.x *= -1

func toggle_flip_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	$Collider.position.x *= -1
	$Hitbox/CollisionShape2D.position.x *= -1
	$BaseShootPos.position.x *= -1
	$Position2D.position.x *= -1
func set_flip_direction(value: bool) -> void:
	$Sprite.flip_h = value
	$AnimatedSprite.flip_h = value
	if value == true:
		$Collider.position.x *= -1
		$Hitbox/CollisionShape2D.position.x *= -1
		$BaseShootPos.position.x *= -1
	flip_direction = value
func _replace_with_spawner() -> void:
	spawn_info["primary_color"] = primary_color
	spawn_info["secondary_color"] = secondary_color
	._replace_with_spawner()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
