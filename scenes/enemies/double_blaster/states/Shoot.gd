extends "common.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SHOT = preload("res://scenes/enemies/double_blaster/projectiles/basic_shot.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------
var shoot_count = 0
#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _ready():
	$"../../BetweenBulletTimer".connect("timeout",self,"shoot")

func _enter():
	shoot_count = 0
	shoot()
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if !owner.is_dead:
		shoot_count += 1
		$"../../AnimatedSprite".play("Shoot")
		var shot = SHOT.instance()
		shot.damage = owner.projectile_damage
		shot.direction = owner.get_facing_direction()
		Physics.current_stage.call_deferred("add_child",shot)
		shot.set_deferred("global_position", $"../../BaseShootPos".global_position)
		yield($"../../AnimatedSprite","animation_finished")
		$"../../AnimatedSprite".play("Idle")
	if shoot_count == 2:
		emit_signal("finished", "idle")
	else:
		$"../../BetweenBulletTimer".start()
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
