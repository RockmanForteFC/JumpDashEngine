tool
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

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	pass

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func toggle_flip_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h
	$Collider.position.x *= -1
	$Hitbox/CollisionShape2D.position.x *= -1
	$BaseShootPos.position.x *= -1
	$Hitbox/CollisionShape2D2.position.x *= -1

func set_flip_direction(value: bool) -> void:
	$Sprite.flip_h = value
	if value == true:
		$Collider.position.x *= -1
		$Hitbox/CollisionShape2D.position.x *= -1
		$BaseShootPos.position.x *= -1
		$Hitbox/CollisionShape2D2.position.x *= -1
	flip_direction = value
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func get_middle_section_collision():
	if flip_direction == true:
		$Hitbox/CollisionShape2D2.position.x *= -1
#-------------------------------------------------
#      Connections
#-------------------------------------------------
