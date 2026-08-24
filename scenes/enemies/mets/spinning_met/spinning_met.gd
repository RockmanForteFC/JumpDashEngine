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
func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if "consumed" in body and body.consumed:
			return
		elif is_blocking:
			if body.is_in_group("TremorPulseP1"):
				_take_damage(body.damage,false)
			elif not body.is_piercing :
				body.reflect()
		else:
			if not is_dead:
				_hit_sound.play()
				if body.is_in_group("SonSonShooterP1"):
					_show_score = true
				var buster_damage: int = 1 if not "damage" in body else body.damage
				if buster_damage <= _hit_points:
					if not body.is_piercing:
						body.queue_free()
					elif body.is_piercing and body.breaks_on_enemy:
						body.queue_free()
				_animations.play("Blink")

				var was_beast_net = body.is_in_group("BeastNetP1")
				if check_is_weakness(body.element):
					if buster_damage == 0:
						buster_damage = 1
					buster_damage *= 2
				_take_damage(buster_damage,false, was_beast_net)



	if body and body.is_in_group("Trap"):
		if not is_dead:
			_external_damage(body.damage)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
