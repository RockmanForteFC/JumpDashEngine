extends "res://scenes/enemies/base/scripts/state_machine.gd"

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const CANNON_BOMB = preload("res://scenes/enemies/shield_cannon/cannon_bomb/cannon_bomb.tscn")
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
	$"../TripleShootTimer".connect("timeout",self, "shoot")
	states_map["idle"] = $Idle
	states_map["shoot"] = $Shoot

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func shoot():
	if shoot_count == 3:
		shoot_count = 0
	elif not owner.is_dead and shoot_count <=2:
		shoot_count += 1
		$"../Audio/Shoot".play()
		var bomb = CANNON_BOMB.instance()
		bomb.set_flip_direction(owner.get_facing_direction().x == 1)
		bomb.contact_damage = owner.projectile_damage
		if shoot_count == 1:
			bomb.thrust = -250
			bomb.distance = 200
		elif shoot_count == 2:
			bomb.thrust = -200
			bomb.distance = 170
		elif shoot_count == 3:
			bomb.thrust = -100
			bomb.distance = 140
		owner.get_parent().add_child(bomb)
		bomb.connect("enemy_died",Statistics, "_on_enemy_died", [bomb.enemy_name])
		bomb.global_position = $"../BaseShootPos".global_position
		$"../TripleShootTimer".start()

func enable_blocking():
	owner.is_blocking = true

func disable_blocking():
	owner.is_blocking = false
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
