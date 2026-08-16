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
	$"../../AnimationPlayer".play("floatdown")
	
func _update(delta):
	get_parent().velocity.y = \
		clamp(get_parent().velocity.y + Physics.GRAVITY_WATER, -Physics.FALL_SPEED_MAX_IN_WATER, Physics.FALL_SPEED_MAX_IN_WATER)
	owner.move_and_slide(get_parent().velocity, Vector2.UP)
	if owner.is_on_floor():
		get_parent().velocity = Vector2.ZERO
		$"../../AnimationPlayer".play("popdown")

#-------------------------------------------------
#      Public Methods
#-------------------------------------------------

#-------------------------------------------------
#      Private Methods
#-------------------------------------------------

#-------------------------------------------------
#      Connections
#-------------------------------------------------

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == ("popdown"):
		emit_signal("finished", "idle")
