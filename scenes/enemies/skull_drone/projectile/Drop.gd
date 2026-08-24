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

func _update(delta):
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)
	owner.move_and_slide_with_snap(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		owner._die(true)
	if owner.is_on_wall():
		owner._die(true)
	if owner.is_on_ceiling():
		owner._die(true)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
