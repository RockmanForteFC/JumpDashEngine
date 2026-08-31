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
var is_awake:bool = false
export(int) var starting_timer:int = 9
var timer:int = 9
var animation_modifier:String = ""
var current_state = "idle"
export(bool)var can_jump:bool = false
var push_direction: Vector2
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	timer = starting_timer
	is_blocking = true
	if can_jump:
		$JumpTimer.connect("timeout",self,"jump")
		$JumpTimer.start()
	$CountDownTimer.connect("timeout",self,"countdown")
	$Sprite/AnimatedSprite.play(str(timer))
	$CountDownTimer.start()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

func _replace_with_spawner() -> void:
	._replace_with_spawner()
	spawn_info["can_jump"] = can_jump
	spawn_info["starting_timer"] = starting_timer

func countdown():
	timer -= 1
	$Audio/tick.play()
	if timer != 0:
		$Sprite/AnimatedSprite.play(str(timer))
		if timer <= 3 and animation_modifier == "":
			animation_modifier = "_Ring"
			if current_state == "freakout":
				pass
			elif current_state == "walk":
				var pos = $AnimationPlayer.current_animation_position
				$AnimationPlayer.play("Walk_Ring")
				$AnimationPlayer.seek(pos, true)
			elif current_state == "jump_up":
				$AnimationPlayer.play("JumpUp_Ring")
			elif current_state == "jump_down":
				$AnimationPlayer.play("JumpDown_Ring")
			elif current_state == "freakout":
				pass
		$CountDownTimer.start()
	elif timer == 0:
		is_dead = true
		_die(!current_state == "freakout")

func jump():
	if !is_dead:
		if current_state ==  "walk":
			emit_signal("change_state","jump_up")

func _die(prevent_appending_to_user_stats:bool = false, was_beast_net:bool = false) -> void:
	is_dead = true
	if  not prevent_appending_to_user_stats:
		Score.change(score)
		emit_signal("enemy_died")
	_is_collidable = false  # Player can no longer collide with enemy.
	if _player_collision_area:
		# Is no longer hittable by player projectiles.
		_player_collision_area.set_collision_layer_bit(Bitmask.projectile, false)
		_player_collision_area.set_collision_layer_bit(Bitmask.player, false)
		$left/CollisionShape2D.set_deferred("disabled",true)
		$right/CollisionShape2D.set_deferred("disabled",true)
	if was_beast_net:
		if Discs.enemy_bestiary.has(enemy_name) and Discs.enemy_bestiary[enemy_name] == false:
			Discs.enemy_bestiary[enemy_name] = true
			emit_signal("change_state","capture")
		else:
			emit_signal("change_state", "explode")
	else:
		emit_signal("change_state", "explode")
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------
func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		body.did_hit_enemy = true
		if "consumed" in body and body.consumed:
			return
		elif is_blocking:
			if body.is_in_group("BeastNetP1"):
				_animations.play("Blink")
				var was_beast_net = body.is_in_group("BeastNetP1")
				_take_damage(3,false, was_beast_net)
			if not body.is_piercing:
				body.reflect()
		else:
			if not is_dead:
				_hit_sound.play()
				var buster_damage: int = 1 if not "damage" in body else body.damage
				if buster_damage <= _hit_points:
					if not body.is_piercing:
						body.queue_free()
					elif body.is_piercing and body.breaks_on_enemy:
						body.queue_free()
				_animations.play("Blink")
				var was_beast_net = body.is_in_group("BeastNetP1")
				_take_damage(buster_damage,false, was_beast_net)
	if body and body.is_in_group("Trap"):
		if not is_dead:
			_external_damage(body.damage)
#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Explosion_Damage_Radius_body_entered(body):
	if body is Player:
		body.on_hit(projectile_damage,Physics.Damage.projectile,Physics.Element.fire)


func _on_left_body_entered(body):
	if current_state != "freakout" and (body and body.is_in_group("PlayerWeapons")):
		if body.is_in_group("TremorPulseP1") or body.is_in_group("ShinyKnuckleP1"):
			emit_signal("change_state","freakout")
			return
		if current_state != "push":
			push_direction = Vector2.RIGHT
			emit_signal("change_state","push")

func _on_right_body_entered(body):
	if current_state != "freakout" and (body and body.is_in_group("PlayerWeapons")):
		if body.is_in_group("TremorPulseP1") or body.is_in_group("ShinyKnuckleP1"):
			emit_signal("change_state","freakout")
			return
		if current_state != "push":
			push_direction = Vector2.LEFT
			emit_signal("change_state","push")
