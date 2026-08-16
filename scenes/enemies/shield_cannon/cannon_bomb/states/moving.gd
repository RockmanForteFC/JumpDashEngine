extends State

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

func _enter():
	get_parent().velocity = Vector2(owner.get_facing_direction().x * owner.distance, owner.thrust)

func _update(delta):
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide_with_snap(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		owner._die()
	elif owner.is_on_ceiling():
		owner._die()
	elif owner.is_on_wall():
		owner._die()

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_animation_finished(anim_name):
	pass
