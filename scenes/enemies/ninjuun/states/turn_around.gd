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
	$"../../AnimationPlayer".play("turn")

func _update(delta):
	owner.move_and_slide(get_parent().velocity,Vector2.UP)
	get_parent().velocity.y = clamp(get_parent().velocity.y + Physics.GRAVITY_WATER,-Physics.FALL_SPEED_MAX, Physics.FALL_SPEED_MAX)

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
	if anim_name == "turn":
		emit_signal("finished", "down")
