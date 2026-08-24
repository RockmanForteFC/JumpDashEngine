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
export(float,0,5) var timer := 3.0
export(String,"Down","Up") var starting_direction := "Down"
export(Color) var color:Color = Color("E40058")
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$Sprite.material.set_shader_param("replace_0", color)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _replace_with_spawner() -> void:
	spawn_info["timer"] = timer
	spawn_info["starting_direction"] = starting_direction
	spawn_info["color"] = color
	._replace_with_spawner()

func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if "consumed" in body and body.consumed:
			return
		elif is_blocking:
			if not body.is_piercing:
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
				if was_beast_net:
					buster_damage = 5
				_take_damage(buster_damage,false, was_beast_net)
	if body and body.is_in_group("Trap"):
		if not is_dead:
			_external_damage(body.damage)
#-------------------------------------------------
#      Connections
#-------------------------------------------------
