extends State

#-------------------------------------------------
#      Constants
#-------------------------------------------------
const JUMP_VELOCITY:float = -200.0
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
	get_parent().velocity.y = JUMP_VELOCITY
	$"../../AnimationPlayer".play("Jump")

func _update(delta):
	get_parent().velocity.y =  clamp(get_parent().velocity.y + Physics.GRAVITY, -Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)

	if owner.is_on_floor():
		get_parent().velocity.x = 0
		emit_signal("finished","walk")
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------
