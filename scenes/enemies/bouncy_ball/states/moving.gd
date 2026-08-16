extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const PARTICLES = preload("res://scenes/enemies/kumotek/Particles2D.tscn")
#-------------------------------------------------
#      Signals
#-------------------------------------------------

#-------------------------------------------------
#      Properties
#-------------------------------------------------

#-------------------------------------------------
#      Processes
#-------------------------------------------------

func _enter():
	get_parent().velocity = Vector2(owner.direction.x * owner.moving_speed, owner.direction.y * owner.moving_speed)

func _update(delta):
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	
	if owner.is_on_ceiling() or owner.is_on_floor():
		make_particles()
		owner.direction.y *= -1
		get_parent().velocity = Vector2(owner.direction.x * owner.moving_speed, owner.direction.y * owner.moving_speed)

	elif  owner.is_on_wall():
		make_particles()
		owner.direction.x *= -1
		get_parent().velocity = Vector2(owner.direction.x * owner.moving_speed , owner.direction.y * owner.moving_speed)

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------
func make_particles():
	$"../../AnimationPlayer".play("shine")
	$"../../Audio/change_direction".play()
	var p = PARTICLES.instance()
	owner.get_parent().call_deferred("add_child",p)
	p.set_deferred("global_position",owner.global_position)
#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
