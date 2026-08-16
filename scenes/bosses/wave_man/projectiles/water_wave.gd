extends Node2D

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const DAMAGE = 3
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
export (Physics.Element)var element:int = Physics.Element.water
export (Physics.Damage)var damage_type:int = Physics.Damage.projectile
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _enable_collision():
	$Area2D/CollisionShape2D.disabled = false
func _disable_collision():
	$Area2D/CollisionShape2D.disabled = true
#-------------------------------------------------
#      Connections
#-------------------------------------------------
func on_animation_finished(anim_name):
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if not body.is_piercing:
			body.reflect()
