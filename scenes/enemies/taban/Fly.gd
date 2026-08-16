extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const SPEED:float = 15.0
const SHOT = preload("res://scenes/enemies/projectiles/targeted_shot.tscn")
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
func _enter():
	$"../../Audio/Fly".play()
	$"../../AnimationPlayer".play("fly")
	$"../../Timer".start()
func _update(delta):
	var direction = (PlayerValues.player.global_position - owner.global_position).normalized()
	owner.move_and_slide(direction * SPEED)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func _shoot():
	var s = SHOT.instance()
	s.speed = 100
	s.damage = owner.projectile_damage
	s.damage_type = Physics.Damage.projectile
	s.element = Physics.Element.neutral
	s.direction = (PlayerValues.player.global_position - $"../../BaseShootPos".global_position)
	owner.get_parent().call_deferred("add_child",s)
	s.set_deferred("global_position", owner.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------


func _on_Timer_timeout():
	if !owner.is_dead:
		_shoot()
	$"../../Timer".start()
